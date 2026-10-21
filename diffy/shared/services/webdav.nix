{ bundleLib, self, ... }:
let
  domain = "dav.diffy.wtf";
  port = 6065;
in
bundleLib.mkEnableModule [ "dyad" "services" "webdav" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
    tailscale.enable = true;
  };

  nixos = { config, lib, ... }: {
    age.secrets."webdav/seedvault".file = self + /diffy/secrets/webdav/seedvault.age;

    services.webdav = {
      enable = true;
      environmentFile = config.age.secrets."webdav/seedvault".path;
      settings = {
        address = "127.0.0.1";
        inherit port;
        prefix = "/files";
        behindProxy = true;
        directory = "/var/lib/webdav";
        permissions = "CRUD";
        users = lib.singleton {
          username = "{env}WEBDAV_USERNAME";
          password = "{env}WEBDAV_PASSWORD";
        };
      };
    };

    systemd.services.webdav.serviceConfig.StateDirectory = "webdav";

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;

      # 443 is public for other services, this one is tailnet only
      extraConfig = ''
        allow 100.64.0.0/10;
        deny all;
      '';

      locations."/".return = "404";

      locations."/files" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        extraConfig = ''
          client_max_body_size 0;
          proxy_request_buffering off;

          # COPY and MOVE need the destination as a path, not a url
          set $dest $http_destination;
          if ($http_destination ~ "^https?://[^/]+(?<path>/.*)$") {
            set $dest $path;
          }
          proxy_set_header Destination $dest;
        '';
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];

    keep.safe.dirs = [ "/var/lib/webdav" ];
  };
}

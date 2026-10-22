{ bundleLib, self, ... }:
let
  domain = "cal.diffy.wtf";
  port = 5232;
in
bundleLib.mkEnableModule [ "dyad" "services" "radicale" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
    tailscale.enable = true;
  };

  nixos = { config, ... }: {
    age.secrets."radicale/htpasswd" = {
      file = self + /diffy/secrets/radicale/htpasswd.age;
      owner = "radicale";
    };

    services.radicale = {
      enable = true;
      settings = {
        server.hosts = [ "127.0.0.1:${toString port}" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = config.age.secrets."radicale/htpasswd".path;
          htpasswd_encryption = "bcrypt";
        };
      };
    };

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;

      extraConfig = ''
        allow 100.64.0.0/10;
        deny all;
      '';

      locations."/".proxyPass = "http://127.0.0.1:${toString port}";
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];

    keep.safe.dirs = [ "/var/lib/radicale" ];
  };
}

{ bundleLib, self, ... }:
let
  domain = "cloud.diffy.wtf";
  port = 9200;
in
bundleLib.mkEnableModule [ "dyad" "services" "opencloud" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
  };

  nixos = { config, pkgs, ... }: {
    age.secrets."opencloud/s3".file = self + /diffy/secrets/opencloud/s3.age;
    age.secrets."opencloud/admin".file = self + /diffy/secrets/opencloud/admin.age;

    services.opencloud = {
      enable = true;
      # switching to the rolling release later is one way, it cannot downgrade
      package = pkgs.opencloud-production;
      inherit port;
      url = "https://${domain}";
      environment = {
        OC_INSECURE = "true";
        PROXY_TLS = "false";
        OC_SHARING_PUBLIC_SHARE_MUST_HAVE_PASSWORD = "false";
        OC_SHARING_PUBLIC_WRITEABLE_SHARE_MUST_HAVE_PASSWORD = "true";
        FRONTEND_ARCHIVER_MAX_SIZE = "21474836480"; # 20GiB

        # metadata stays under the state dir, blobs go to r2
        STORAGE_USERS_DRIVER = "decomposeds3";
        STORAGE_USERS_DECOMPOSEDS3_ENDPOINT = "https://91904b557339948e9098d680e823dd3e.r2.cloudflarestorage.com";
        STORAGE_USERS_DECOMPOSEDS3_REGION = "auto";
        STORAGE_USERS_DECOMPOSEDS3_BUCKET = "opencloud";
      };
      environmentFile = config.age.secrets."opencloud/s3".path;
    };

    # idm only reads this when it creates its database, later changes need opencloud idm resetpassword
    systemd.services.opencloud.serviceConfig.EnvironmentFile = [
      config.age.secrets."opencloud/admin".path
    ];

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 0;
          proxy_request_buffering off;
          # server-sent events stall behind the buffer
          proxy_buffering off;
          proxy_read_timeout 1h;
        '';
      };
    };

    networking.firewall.allowedTCPPorts = [ 443 ];

    keep.safe.dirs = {
      # generated service secrets from the first start
      "/etc/opencloud" = { };
      "/var/lib/opencloud" = {
        user = "opencloud";
        group = "opencloud";
        mode = "0750";
      };
    };
  };
}

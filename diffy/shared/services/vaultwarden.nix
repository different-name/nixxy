{ bundleLib, ... }:
let
  domain = "vault.diffy.wtf";
  port = 8222;
in
bundleLib.mkEnableModule [ "dyad" "services" "vaultwarden" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
    tailscale.enable = true;
  };

  nixos = {
    services.vaultwarden = {
      enable = true;
      inherit domain;
      # restic copying the live sqlite file can catch it mid-write, this keeps a consistent copy for it
      backupDir = "/var/backup/vaultwarden";
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = port;
        SIGNUPS_ALLOWED = false;
      };
    };

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;

      # send links need /identity public, which would expose the login too
      extraConfig = ''
        allow 100.64.0.0/10;
        deny all;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 525M;
        '';
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];

    keep.safe.dirs = {
      "/var/backup/vaultwarden" = {
        user = "vaultwarden";
        group = "vaultwarden";
        mode = "0770";
      };
      "/var/lib/vaultwarden" = { };
    };
  };
}

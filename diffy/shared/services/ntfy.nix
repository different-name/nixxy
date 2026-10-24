{ bundleLib, lib, ... }:
let
  domain = "push.diffy.wtf";
  port = 2586;
in
bundleLib.mkEnableModule [ "dyad" "services" "ntfy" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
    tailscale.enable = true;
  };

  nixos = {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${domain}";
        listen-http = "127.0.0.1:${toString port}";
        behind-proxy = true;
      };
    };

    # a dynamic user would move its state under /var/lib/private
    systemd.services.ntfy-sh.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "ntfy-sh";
      Group = "ntfy-sh";
    };
    users.users.ntfy-sh = {
      isSystemUser = true;
      group = "ntfy-sh";
    };
    users.groups.ntfy-sh = { };

    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      acmeRoot = null;
      forceSSL = true;

      extraConfig = ''
        allow 100.64.0.0/10;
        deny all;
      '';

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_buffering off;
          proxy_read_timeout 3h;
        '';
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];

    keep.safe.dirs."/var/lib/ntfy-sh" = {
      user = "ntfy-sh";
      group = "ntfy-sh";
    };
  };
}

{
  bundleLib,
  self,
  lib,
  ...
}:
let
  domain = "molly.diffy.wtf";
  port = 8020;
in
bundleLib.mkEnableModule [ "dyad" "services" "mollysocket" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
    ntfy.enable = true;
    tailscale.enable = true;
  };

  nixos = { config, ... }: {
    age.secrets."mollysocket/env".file = self + /diffy/secrets/mollysocket/env.age;

    services.mollysocket = {
      enable = true;
      settings = {
        host = "127.0.0.1";
        inherit port;
        allowed_endpoints = [ "https://push.diffy.wtf" ];
      };
      environmentFile = config.age.secrets."mollysocket/env".path;
    };

    # a dynamic user would move its state under /var/lib/private
    systemd.services.mollysocket.serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "mollysocket";
      Group = "mollysocket";
      StateDirectoryMode = "0700";
    };
    users.users.mollysocket = {
      isSystemUser = true;
      group = "mollysocket";
    };
    users.groups.mollysocket = { };

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

    keep.safe.dirs."/var/lib/mollysocket" = {
      user = "mollysocket";
      group = "mollysocket";
      mode = "0700";
    };
  };
}

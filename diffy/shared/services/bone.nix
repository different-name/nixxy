{
  bundleLib,
  inputs,
  self,
  lib,
  ...
}:
let
  domain = "mail.diffy.wtf";
  port = 8790;

  accounts = [
    "catch"
    "main"
  ];
  devices = [
    "lithium"
    "potassium"
    "sodium"
  ];

  secret = name: { "bone/${name}".file = self + /diffy/secrets/bone/${name}.age; };
in
bundleLib.mkEnableModule [ "dyad" "services" "bone" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
    ntfy.enable = true;
    tailscale.enable = true;
  };

  nixos =
    { config, ... }:
    let
      path = name: config.age.secrets."bone/${name}".path;
    in
    {
      imports = [ inputs.diffys-attic.nixosModules.server ];

      age.secrets = lib.mergeAttrsList (
        lib.concatMap (a: [
          (secret "${a}-login")
          (secret "${a}-password")
        ]) accounts
        ++ map (d: secret "device-${d}") devices
      );

      services.bone = {
        enable = true;
        bind = "127.0.0.1:${toString port}";
        accounts = lib.genAttrs accounts (a: {
          loginFile = path "${a}-login";
          passwordFile = path "${a}-password";
          catchAll = a == "catch";
          color = if a == "catch" then "mauve" else "green";
          domains = lib.optional (a == "catch") "different-name.dev";
        });
        devices = lib.genAttrs devices (d: {
          tokenFile = path "device-${d}";
        });
      };

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
          extraConfig = ''
            client_max_body_size 50M;
          '';
        };

        # server-sent events stall behind the default proxy buffer
        locations."/api/events" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 1h;
          '';
        };
      };

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 443 ];

      keep.safe.dirs."/var/lib/bone" = {
        user = "bone";
        group = "bone";
        mode = "0700";
      };
      keep.loose.dirs."/var/cache/bone" = {
        user = "bone";
        group = "bone";
        mode = "0700";
      };
    };
}

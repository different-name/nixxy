{
  lib,
  config,
  inputs,
  inputs',
  self,
  ...
}:
let
  accounts = [
    "diffy"
    "nero"
  ];

  serverDomain = "copyparty.different-name.com";
in
{
  imports = [
    inputs.copyparty.nixosModules.default
  ];

  options.dyad.services.copyparty.enable = lib.mkEnableOption "copyparty config";

  config = lib.mkIf config.dyad.services.copyparty.enable {
    services.copyparty = {
      enable = true;
      package = inputs'.copyparty.packages.copyparty;

      volumes = {
        "/" = {
          path = "/srv/copyparty";
          access.rwmda = [ "diffy" ];
        };

        "/shared/nero" = {
          path = "/srv/copyparty/shared/nero";
          access = {
            rwmda = [ "diffy" ];
            rwmd = [ "nero" ];
          };
        };
      };

      accounts = lib.genAttrs accounts (account: {
        passwordFile = config.age.secrets."copyparty/${account}".path;
      });
    };

    age.secrets = lib.listToAttrs (
      map (account: {
        name = "copyparty/${account}";
        value = {
          file = self + /secrets/copyparty/${account}.age;
          owner = "copyparty";
          group = "copyparty";
        };
      }) accounts
    );

    services.caddy.virtualHosts.${serverDomain}.extraConfig = ''
      reverse_proxy 127.0.0.1:3923
    '';

    services.cloudflare-dyndns.domains = [ serverDomain ];

    environment.perpetual.default.dirs = [
      {
        directory = "/var/lib/copyparty";
        user = "copyparty";
        group = "copyparty";
      }
      {
        directory = "/srv/copyparty";
        user = "copyparty";
        group = "copyparty";
      }
    ];

    # dependency
    dyad.system.agenix.enable = true;
  };
}

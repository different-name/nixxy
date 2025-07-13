{
  lib,
  inputs,
  self,
  ...
}:
let
  dyadLib = {
    mkHost =
      {
        hostName,
        machineId,
        stateVersion,
      }:
      hostConfig: {
        imports = [
          {
            networking = {
              inherit hostName;
              hostId = builtins.substring 0 8 machineId;
            };

            environment.etc.machine-id.text = machineId;

            # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
            system = { inherit stateVersion; };
          }
          hostConfig
        ];
      };

    mkUser =
      {
        config,
        username,
        homeConfig ? null,
      }:
      userConfig:
      let
        cfg = config.dyad.users.${username};
      in
      {
        options.dyad.users.${username} = {
          enable = lib.mkEnableOption "user ${username}";
        };

        config = lib.mkIf cfg.enable (
          lib.mkMerge [
            (lib.mkIf (homeConfig != null) {
              home-manager.users.${username} =
                { config, osConfig, ... }:
                {
                  imports = [
                    {
                      home = {
                        inherit username;
                        inherit (osConfig.system) stateVersion;
                      };

                      programs.nh = {
                        enable = true;
                        package = lib.mkDefault osConfig.programs.nh.package;
                        flake = "${config.home.homeDirectory}/nix-files";
                      };
                    }
                    (inputs.import-tree (self + /dyad/home))
                    homeConfig
                  ];
                };
            })

            (lib.mkIf config.dyad.system.agenix.enable {
              # access to the hostkey independent of impermanence activation
              age.identityPaths = lib.mkIf config.dyad.system.agenix.enable [
                "/persist/home/${username}/.ssh/id_ed25519"
              ];
              # user password secret
              age.secrets."${username}/user-password".file = self + /secrets/${username}/user-password.age;
              users.users.${username}.hashedPasswordFile = config.age.secrets."${username}/user-password".path;
            })

            userConfig
          ]
        );
      };
  };
in
{
  flake.lib = dyadLib;
}

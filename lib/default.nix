{
  lib,
  inputs,
  self,
  ...
}:
let
  dyadLib = {
    collectAspectModules =
      type:
      builtins.readDir (self + /aspects)
      |> lib.filterAttrs (name: _: lib.pathIsDirectory (self + /aspects/${name}/${type}))
      |> lib.mapAttrsToList (name: _: self + /aspects/${name}/${type})
      |> inputs.import-tree;

    mkHost =
      {
        hostName,
        machineId,
        stateVersion,
      }:
      hostConfig: {
        imports = [
          hostConfig

          {
            networking = {
              inherit hostName;
              hostId = builtins.substring 0 8 machineId;
            };

            environment.etc.machine-id.text = machineId;

            # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
            system = { inherit stateVersion; };
          }
        ];
      };

    mkUser =
      {
        config,
        username,
        uid,
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
                    homeConfig
                    (dyadLib.collectAspectModules "home")

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
                  ];
                };
            })

            (
              let
                inherit (config.home-manager.users.${username}) home;
                inherit (home) homeDirectory;
                inherit (home.persistence.default) persistentStoragePath;
                persistentHomeDirectory = persistentStoragePath + homeDirectory;
              in
              lib.mkIf config.dyad.system.agenix.enable {
                # access to the hostkey independent of impermanence activation
                age.identityPaths = [
                  "${persistentHomeDirectory}/.ssh/id_ed25519"
                ];
                # user password secret
                age.secrets."user-passwords/${username}".file = self + /secrets/user-passwords/${username}.age;
                users.users.${username}.hashedPasswordFile = config.age.secrets."user-passwords/${username}".path;
              }
            )

            { users.users.${username} = { inherit uid; }; }
            userConfig
          ]
        );
      };
  };
in
{
  flake.lib = dyadLib;
}

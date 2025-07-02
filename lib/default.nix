{ lib, ... }:
{
  flake.lib =
    let
      mkHost =
        {
          config,
          hostName,
          machineId,
          diskConfiguration,
          stateVersion,
          content,
        }:
        {
          config = lib.mkIf (config.nix-files.host == hostName) (
            lib.mkMerge [
              {
                networking = {
                  inherit hostName;
                  hostId = builtins.substring 0 8 machineId;
                };
                environment.etc.machine-id.text = machineId;
                # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
                system = { inherit stateVersion; };
              }
              (import diskConfiguration)
              content
            ]
          );
        };

      mkUser =
        {
          config,
          username,
          content,
        }:
        let
          cfg = config.nix-files.users.${username};
        in
        {
          options.nix-files.users.${username} = {
            enable = lib.mkEnableOption "user ${username}";
          };
          config = lib.mkIf cfg.enable (
            lib.mkMerge [
              {
                home-manager.users.${username} =
                  {
                    config,
                    osConfig,
                    inputs,
                    ...
                  }:
                  {
                    imports = [
                      (inputs.import-tree (inputs.self + /home))
                    ];

                    nix-files.home = {
                      user = username;
                      host = lib.mkForce osConfig.nix-files.host;
                      flake = "${config.home.homeDirectory}/nix-files";
                    };

                    home = {
                      inherit username;
                      inherit (osConfig.system) stateVersion;
                      homeDirectory = "/home/${config.home.username}";
                      sessionVariables.NH_FLAKE = "${config.nix-files.home.flake}";
                    };
                  };
              }
              content
            ]
          );
        };
    in
    {
      inherit
        mkHost
        mkUser
        ;
    };
}

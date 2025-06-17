{
  lib,
  config,
  pkgs,
  inputs,
  ...
}@args:
let
  machine-id = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
in
{
  config = lib.mkIf (config.nix-files.host == "potassium") (
    lib.mkMerge [
      {
        nix-files = {
          users.different.enable = true;

          profiles = {
            global.enable = true;
            graphical.enable = true;
            laptop.enable = true;
          };

          parts = {
            hardware = {
              nvidia.enable = true;
            };

            nix = {
              distributed-builds.enable = true;
            };

            system = {
              autologin = {
                enable = true;
                user = "different";
              };
            };
          };
        };

        ### host specific

        hardware.nvidia.prime = {
          nvidiaBusId = "PCI:1:0:0";
          intelBusId = "PCI:0:2:0";
        };

        ### boilerplate

        networking = {
          hostName = "potassium";
          hostId = builtins.substring 0 8 machine-id;
        };

        environment.etc.machine-id.text = machine-id;

        programs.nh.flake = "/home/different/nix-files";

        # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "24.05";
      }

      (inputs.self.lib.flattenImports [
        ./_hardware-configuration.nix
        ./_disk-configuration.nix
      ] args)
    ]
  );
}

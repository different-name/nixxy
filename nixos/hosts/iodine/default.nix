{
  lib,
  config,
  pkgs,
  ...
}@args:
let
  machine-id = "294b0aee9a634611a9ddef5e843f4035";
in
{
  config = lib.mkIf (config.nix-files.host == "iodine") (
    lib.mkMerge [

      {
        nix-files = {
          users.iodine.enable = true;

          profiles.global.enable = true;

          parts = {
            nix = {
              distributed-builds.enable = true;
            };

            services = {
              cloudflare-dyndns.enable = true;

              minecraft-server = {
                enable = true;
                maocraft.enable = true;
                buhguh.enable = true;
                maodded.enable = true;
              };
            };
          };
        };

        ### host specific

        # TODO temporary rollback on iodine for password issues
        security.sudo.wheelNeedsPassword = lib.mkForce false;

        ### boilerplate

        networking = {
          hostName = "iodine";
          hostId = builtins.substring 0 8 machine-id;
        };

        environment.etc.machine-id.text = machine-id;

        programs.nh.flake = "/home/iodine/nix-files";

        hardware.enableRedistributableFirmware = true;

        # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "24.05";
      }

      (import ./_disk-configuration.nix)
      (lib.removeAttrs (import ./_hardware-configuration.nix args) [ "imports" ])
    ]
  );
}

{
  lib,
  config,
  inputs,
  ...
}:
let
  machine-id = "9471422d94d34bb8807903179fb35f11";
in
{
  config = lib.mkIf (config.nix-files.host == "sodium") (
    lib.mkMerge [
      {
        nix-files = {
          users.different.enable = true;

          profiles = {
            global.enable = true;
            graphical.enable = true;
          };

          parts = {
            hardware = {
              nvidia.enable = true;
            };

            nix = {
              build-host.enable = true;
            };

            services = {
              keyd.enable = true;
              xr.enable = true;
            };

            system = {
              autologin = {
                enable = true;
                user = "different";
              };

              btrfs.backup-script = {
                enable = true;
                backup-disk-uuid = "a5091625-835c-492f-8d99-0fc8d27012a0";
                crypt-name = "backup_drive";
                mount = "/mnt/backup";
                subvolume = "/btrfs/persist";
              };
            };
          };
        };

        ### host specific

        environment.sessionVariables = {
          STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
          GDK_SCALE = "2";
        };

        hardware.keyboard.qmk.enable = true;
        services.goxlr-utility.enable = true;

        # mirror audio from goxlr outputs to wivrn output
        services.pipewire.wireplumber.connectPorts = [
          {
            output = {
              constraint = "GoXLR:monitor_*";
              leftAlias = "GoXLR:monitor_FL";
              rightAlias = "GoXLR:monitor_FR";
            };

            input = {
              constraint = "WiVRn:playback_*";
              leftAlias = "WiVRn:playback_1";
              rightAlias = "WiVRn:playback_2";
            };
          }
        ];

        age.secrets = {
          "syncthing/sodium/key".file = inputs.self + /secrets/syncthing/sodium/key.age;
          "syncthing/sodium/cert".file = inputs.self + /secrets/syncthing/sodium/cert.age;
        };

        nix-files.parts.services.syncthing = {
          enable = true;
          user = "different";
          key = config.age.secrets."syncthing/sodium/key".path;
          cert = config.age.secrets."syncthing/sodium/cert".path;
        };

        ### boilerplate

        networking = {
          hostName = "sodium";
          hostId = builtins.substring 0 8 machine-id;
        };

        environment.etc.machine-id.text = machine-id;

        programs.nh.flake = "/home/different/nix-files";

        # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "24.05";
      }

      (import ./_disk-configuration.nix)
    ]
  );
}

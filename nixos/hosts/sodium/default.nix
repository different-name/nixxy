{
  lib,
  config,
  pkgs,
  inputs,
  modulesPath,
  ...
}@args:
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
            };
          };
        };

        ### host specific

        hardware.keyboard.qmk.enable = true;
        services.goxlr-utility.enable = true;

        environment.sessionVariables = {
          STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
          GDK_SCALE = "2";
        };

        # script used to backup persist subvolume to external hdd
        environment.systemPackages = [
          (pkgs.writeShellApplication {
            name = "backup-persist";
            text = builtins.readFile ./backup-persist.sh;

            runtimeInputs = with pkgs; [
              cryptsetup
              btrfs-progs
              pv
              udisks
            ];
          })
        ];

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

        # sync files between vr headset and desktop
        age.secrets."syncthing/sodium/key".file = inputs.self + /secrets/syncthing/sodium/key.age;
        age.secrets."syncthing/sodium/cert".file = inputs.self + /secrets/syncthing/sodium/cert.age;
        services.syncthing = {
          enable = true;
          openDefaultPorts = true;

          user = "different";
          group = "users";
          dataDir = "/home/different";

          key = config.age.secrets."syncthing/sodium/key".path;
          cert = config.age.secrets."syncthing/sodium/cert".path;

          settings = {
            devices = {
              "Pico".id = "4EZ7P3H-3G2YWUM-BZDVVN2-7M3OTFZ-IL4KQP5-Z733T66-7CP6J3H-724OCAG";
            };
          };

          overrideFolders = false;
        };
        systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # don't create default ~/Sync folder

        ### boilerplate

        networking = {
          hostName = "sodium";
          hostId = builtins.substring 0 8 machine-id;
        };

        environment.etc.machine-id.text = machine-id;

        programs.nh.flake = "/home/different/nix-files";

        hardware.enableRedistributableFirmware = true;

        # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
        system.stateVersion = "24.05";
      }

      (import ./_disk-configuration.nix)
      (lib.removeAttrs (import ./_hardware-configuration.nix args) [ "imports" ])
    ]
  );
}

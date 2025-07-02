{
  lib,
  config,
  inputs,
  ...
}:
lib.nix-files.mkHost {
  inherit config;

  hostName = "sodium";
  machineId = "9471422d94d34bb8807903179fb35f11";
  diskConfiguration = ./_disk-configuration.nix;
  stateVersion = "24.05";

  content = {
    ### nix-files modules

    age.secrets = {
      "syncthing/sodium/key".file = inputs.self + /secrets/syncthing/sodium/key.age;
      "syncthing/sodium/cert".file = inputs.self + /secrets/syncthing/sodium/cert.age;
    };

    nix-files = {
      users.different.enable = true;

      profiles = {
        global.enable = true;
        graphical.enable = true;
      };

      parts = {
        hardware.nvidia.enable = true;
        nix.build-host.enable = true;

        services = {
          keyd.enable = true;

          syncthing = {
            enable = true;
            user = "different";
            key = config.age.secrets."syncthing/sodium/key".path;
            cert = config.age.secrets."syncthing/sodium/cert".path;
          };

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
    services.pipewire.wireplumber.scripts = {
      autoConnectPorts = [
        {
          output = {
            subject = "port.alias";
            leftPort = "GoXLR:monitor_FL";
            rightPort = "GoXLR:monitor_FR";
          };

          input = {
            subject = "port.alias";
            leftPort = "WiVRn:playback_1";
            rightPort = "WiVRn:playback_2";
          };
        }
      ];
    };
  };
}

{
  bundleLib,
  lib,
  inputs,
  self,
  ...
}:
{
  # declared on every host so modules can add paths without perpetual enabled
  nixos.imports = [ self.nixosModules.perpetual ];
  home-manager.imports = [ self.homeModules.perpetual ];

  imports = lib.singleton (
    bundleLib.mkEnableModule [ "dyad" "system" "perpetual" ] {
      nixos = { config, ... }: {
        imports = [ inputs.impermanence.nixosModules.default ];

        environment.persistence = {
          default = {
            persistentStoragePath = "/persist/system";
            hideMounts = true;
            enableWarnings = true;
          };

          # without a scratch subvolume, volatile data still has to survive reboots
          volatile = {
            persistentStoragePath =
              if config.fileSystems ? "/scratch" then "/scratch/system" else "/persist/system";
            hideMounts = true;
            enableWarnings = true;
          };
        };

        environment.perpetual.volatile = {
          enable = true;
          dirs = [ "/var/cache" ];
        };

        environment.perpetual.default = {
          enable = true;

          dirs = [
            # keep-sorted start
            "/root/.android"
            "/root/.cache"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/systemd/timers"
            "/var/lib/systemd/timesync"
            "/var/log"
            # keep-sorted end
          ];

          files = [ "/var/lib/systemd/random-seed" ];
        };

        # required for impermanence to function
        fileSystems."/persist".neededForBoot = true;
      };

      home-manager = { osConfig, ... }: {
        home.persistence = {
          default = {
            persistentStoragePath = "/persist";
            hideMounts = true;
            enableWarnings = true;
          };

          # without a scratch subvolume, volatile data still has to survive reboots
          volatile = {
            persistentStoragePath = if osConfig.fileSystems ? "/scratch" then "/scratch" else "/persist";
            hideMounts = true;
            enableWarnings = true;
          };
        };

        home.perpetual.volatile.enable = true;

        home.perpetual.default = {
          enable = true;

          dirs = [
            # keep-sorted start
            "$cacheHome/gstreamer-1.0"
            "$cacheHome/gtk-4.0"
            "$dataHome/Trash"
            "$dataHome/pki" # nss certificate db
            ".terminfo"
            "nixxy"
            # keep-sorted end
          ];
        };
      };
    }
  );
}

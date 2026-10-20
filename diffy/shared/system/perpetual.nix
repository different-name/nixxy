{
  bundleLib,
  config,
  lib,
  inputs,
  self,
  ...
}:
{
  # declared on every host so modules can add paths without perpetual enabled
  nixos.imports = [ self.nixosModules.perpetual ];
  home-manager = lib.mkIf config.dyad.users.diffy.enable {
    imports = [ self.homeModules.perpetual ];
  };

  imports = lib.singleton (
    bundleLib.mkEnableModule [ "dyad" "system" "perpetual" ] {
      nixos = {
        imports = [ inputs.impermanence.nixosModules.default ];

        environment.persistence.default = {
          persistentStoragePath = "/persist/system";
          hideMounts = true;
          enableWarnings = true;
        };

        environment.perpetual.default = {
          enable = true;

          dirs = [
            # keep-sorted start
            "/root/.android"
            "/root/.cache"
            "/var/cache"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/systemd/timesync"
            "/var/log"
            # keep-sorted end
          ];

          files = [ "/var/lib/systemd/random-seed" ];
        };

        # required for impermanence to function
        fileSystems."/persist".neededForBoot = true;
      };

      home-manager = {
        home.persistence.default = {
          persistentStoragePath = "/persist";
          hideMounts = true;
          enableWarnings = true;
        };

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

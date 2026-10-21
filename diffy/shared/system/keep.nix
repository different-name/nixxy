{
  bundleLib,
  inputs,
  lib,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "system" "keep" ] {
  imports = lib.singleton {
    # declared on every host so modules can add paths without keep enabled
    nixos = { config, ... }: {
      imports = [ inputs.keep-nix.nixosModules.keep ];

      keep.safe.path = "/persist";
      # without a scratch subvolume, volatile data still has to survive reboots
      keep.loose.path = if config.fileSystems ? "/scratch" then "/scratch" else "/persist";
    };

    home-manager.imports = [ inputs.keep-nix.homeModules.keep ];
  };

  nixos = {
    imports = [ inputs.keep-nix.nixosModules.backend ];

    keep.safe = {
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

    keep.loose.dirs = [ "/var/cache" ];

    # required for keep to function
    fileSystems."/persist".neededForBoot = true;
  };

  home-manager.keep.safe = {
    dirs = [
      ".terminfo"
      "nixxy"
    ];

    cacheDirs = [
      "gstreamer-1.0"
      "gtk-4.0"
    ];

    dataDirs = [
      "Trash"
      "pki" # nss certificate db
    ];
  };
}

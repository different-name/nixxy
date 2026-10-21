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
      imports = [
        inputs.keep-nix.nixosModules.keep
        (import ./_keep-packages.nix {
          inherit inputs;
          format = "nixos";
        })
      ];

      keep.persist.path = "/persist";
      # without a scratch subvolume, volatile data still has to survive reboots
      keep.scratch.path = if config.fileSystems ? "/scratch" then "/scratch" else "/persist";
    };

    home-manager.imports = [
      inputs.keep-nix.homeModules.keep
      (import ./_keep-packages.nix {
        inherit inputs;
        format = "home-manager";
      })
    ];
  };

  nixos = {
    imports = [ inputs.keep-nix.nixosModules.backend ];

    keep.persist = {
      dirs = {
        # keep-sorted start
        "/root/.android" = { };
        "/root/.cache" = { };
        "/var/lib/nixos" = { };
        "/var/lib/systemd/coredump" = { };
        "/var/lib/systemd/timers" = { };
        "/var/lib/systemd/timesync" = { };
        "/var/log" = { };
        # keep-sorted end
      };

      files."/var/lib/systemd/random-seed" = { };
    };

    keep.scratch.dirs."/var/cache" = { };

    # required for keep to function
    fileSystems."/persist".neededForBoot = true;
  };

  home-manager.keep.persist = {
    dirs = {
      ".terminfo" = { };
      "nixxy" = { };
    };

    xdg.cache.dirs = {
      "gstreamer-1.0" = { };
      "gtk-4.0" = { };
    };

    xdg.data.dirs = {
      "Trash" = { };
      "pki" = { }; # nss certificate db
    };
  };
}

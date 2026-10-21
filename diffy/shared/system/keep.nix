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
        inputs.keep-nix.nixosModules.cli
      ];

      keep.safe.path = "/persist";
      # without a scratch subvolume, volatile data still has to survive reboots
      keep.loose.path = if config.fileSystems ? "/scratch" then "/scratch" else "/persist";
    };

    home-manager.imports = [
      inputs.keep-nix.homeModules.keep
      inputs.keep-nix.homeModules.cli
    ];
  };

  nixos = {
    imports = [ inputs.keep-nix.nixosModules.backend ];

    programs.keep.enable = true;

    keep.safe = {
      dirs = [
        # keep-sorted start
        "/root/.android"
        "/root/.cache"
        "/var/lib/lastlog"
        "/var/lib/logrotate"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/lib/systemd/timesync"
        "/var/log"
        # keep-sorted end
      ];

      files = [ "/var/lib/systemd/random-seed" ];
    };

    keep.loose.dirs = [ "/var/cache" ];

    # logrotate renames its state file into place, which a bind-mounted file refuses
    services.logrotate.extraArgs = [
      "-s"
      "/var/lib/logrotate/status"
    ];

    programs.keep.exclude = [
      # keep-sorted start
      "/etc/.clean"
      "/etc/.updated"
      "/etc/NIXOS"
      "/etc/group"
      "/etc/logrotate.conf"
      "/etc/passwd"
      "/etc/shadow"
      "/etc/subgid"
      "/etc/subuid"
      "/var/.updated"
      "/var/lib/systemd/catalog"
      # keep-sorted end
    ];

    # required for keep to function
    fileSystems."/persist".neededForBoot = true;
  };

  home-manager = {
    keep.safe = {
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

    programs.keep.exclude = [
      ".local/state/lesshst" # less history file
      ".pki" # seems to be from chromium, haven't noticed anything wrong having this ephemeral
    ];
  };
}

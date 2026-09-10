{ bundleLib, inputs, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "epht" ] {
  nixos = {
    imports = [ inputs.epht.nixosModules.default ];

    programs.epht = {
      enable = true;

      extraExcludes = [
        # keep-sorted start
        "/.swapvol" # swap
        "/btrfs" # default btrfs subvolume
        "/etc/.clean"
        "/etc/.updated"
        "/etc/NIXOS"
        "/etc/fwupd/fwupd.conf" # services.fwupd
        "/etc/group"
        "/etc/passwd"
        "/etc/resolv.conf" # dns config
        "/etc/shadow"
        "/etc/ssh/authorized_keys.d" # openssh.authorizedKeys
        "/etc/subgid"
        "/etc/subuid"
        "/etc/sudoers"
        "/var/.updated"
        "/var/lib/NetworkManager/NetworkManager-intern.conf"
        "/var/lib/NetworkManager/secret_key" # cannot be persisted as file
        "/var/lib/NetworkManager/timestamps" # cannot be persisted as file
        "/var/lib/systemd/catalog"
        "/var/lib/systemd/timers"
        # keep-sorted end
      ];
    };
  };

  # left disabled, the nixos module folds these excludes into the system manifest
  home-manager = {
    imports = [ inputs.epht.homeModules.default ];

    programs.epht.extraExcludes = [
      # keep-sorted start
      ".cache/Microsoft/DeveloperTools/deviceid" # probably vsc, haven't had issues being ephemeral
      ".cache/thumbnails"
      ".config/dconf/user" # gnome settings database
      ".config/pulse/cookie" # pulseaudio cookie, had no issues with this being unpersisted
      ".local/share/Paradox Interactive" # across the obelisk launcher
      ".local/share/recently-used.xbel" # recent files list used by some applications
      ".local/state/btop.log" # just btop logs
      ".local/state/lesshst" # less history file
      ".paradoxlauncher" # across the obelisk launcher
      ".pki" # seems to be from chromium, haven't noticed anything wrong having this ephemeral
      ".vscode-oss" # seems to be data written by the vscode home-manager module
      # keep-sorted end
    ];
  };
}

{
  lib,
  config,
  self,
  ...
}:
{
  imports = [
    self.nixosModules.epht
  ];

  options.dyad.programs.epht.enable = lib.mkEnableOption "epht config";

  config = lib.mkIf config.dyad.programs.epht.enable {
    programs.epht = {
      enable = true;

      exclude-paths =
        [
          # keep-sorted start
          "/dev"
          "/nix"
          "/proc"
          "/sys"
          "/.swapvol" # swap
          "/boot" # non ephemeral
          "/btrfs" # default btrfs subvolume
          "/etc/.clean"
          "/etc/.updated"
          "/etc/NIXOS"
          "/etc/fwupd/fwupd.conf" # services.fwupd
          "/etc/group"
          "/etc/passwd"
          "/etc/printcap"
          "/etc/resolv.conf" # dns config
          "/etc/shadow"
          "/etc/ssh/authorized_keys.d" # openssh.authorizedKeys
          "/etc/subgid"
          "/etc/subuid"
          "/etc/sudoers"
          "/run" # runtime files
          "/tmp" # temporary files
          "/var/.updated"
          "/var/lib/NetworkManager/NetworkManager-intern.conf"
          "/var/lib/NetworkManager/secret_key" # cannot be persisted as file
          "/var/lib/NetworkManager/timestamps" # cannot be persisted as file
          "/var/lib/systemd/catalog"
          "/var/lib/systemd/timers"
          "/var/tmp" # temporary files
          # keep-sorted end
        ]
        # https://wiki.archlinux.org/title/XDG_Base_Directory
        # TODO this should not be hard coded
        ++ (map (path: "/home/different/${path}") [
          # keep-sorted start
          ".cache/Microsoft/DeveloperTools/deviceid" # probably vsc, haven't had issues being ephemeral
          ".config/VSCodium" # some subfolders are persisted, but I should have everything I need now
          ".config/dconf/user" # gnome settings database
          ".config/fish" # can configure declaratively
          ".config/gtk-2.0"
          ".config/gtk-3.0"
          ".config/pulse/cookie" # pulseaudio cookie, had no issues with this being unpersisted
          ".local/share/Paradox Interactive" # across the obelisk launcher
          ".local/share/applications/mimeapps.list" # can configure declaratively
          ".local/share/mimeapps.list" # xdg mimeapps, managed in config
          ".local/share/recently-used.xbel" # recent files list used by some applications
          ".local/state/btop.log" # just btop logs
          ".local/state/lesshst" # less history file
          ".paradoxlauncher" # across the obelisk launcher
          ".pki" # seems to be from chromium, see above link. I haven't noticed anything wrong having this ephemeral
          ".vscode-oss" # seems to be data written by the vscode home-manager module
          # keep-sorted end
        ]);
    };
  };
}

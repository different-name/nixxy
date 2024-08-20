{self, ...}: {
  imports = [
    self.nixosModules.ephemeral-tools
  ];

  programs.ephemeral-tools = {
    enable = true;

    exclude-paths =
      [
        "/boot" # non ephemeral
        "/run" # runtime files
        "/tmp" # temporary files
        "/var/tmp" # temporary files
        "/etc/shadow"
        "/etc/group"
        "/etc/sudoers"
        "/etc/NIXOS"
        "/etc/subuid"
        "/etc/passwd"
      ]
      ++ (map (path: "/home/different/${path}") [
        # https://wiki.archlinux.org/title/XDG_Base_Directory
        ".steam" # using a full mount to persist this, rather than the impermanence module
        ".local/share/Steam" # ditto the above comment ^
        "Media" # xpool mountpoint
        ".vscode-oss" # seems to be data written by the vscode home-manager module
        ".config/VSCodium" # some subfolders are persisted, but I should have everything I need now
        ".config/fish" # can configure declaratively
        ".local/share/applications/mimeapps.list" # can configure declaratively
        ".pki" # seems to be from chromium, see above link. I haven't noticed anything wrong having this ephemeral
        ".local/share/Paradox Interactive" # across the obelisk launcher
        ".paradoxlauncher" # across the obelisk launcher
        ".local/share/mimeapps.list" # xdg mimeapps, managed in config
        ".local/share/recently-used.xbel" # recent files list used by some applications
        ".config/dconf/user" # gnome settings database
        ".local/state/lesshst" # less history file
      ]);
  };
}

{
  nix-files.tools.ephemeral = {
    enable = true;

    exclude-paths = {
      # https://wiki.archlinux.org/title/XDG_Base_Directory
      home = [
        ".steam" # using a full mount to persist this, rather than the impermanence module
        ".local/share/Steam" # ditto the above comment ^
        ".vscode-oss" # seems to be data written by the vscode home-manager module
        ".config/VSCodium" # some subfolders are persisted, but I should have everything I need now
        ".config/fish" # can configure declaratively
        ".local/share/applications/mimeapps.list" # can configure declaratively
        ".pki" # seems to be from chromium, see above link. I haven't noticed anything wrong having this ephemeral
      ];

      root = [
        "/boot" # non ephemeral
        "/nix" # non ephemeral
        "/persist" # non ephemeral
        "/proc" # virtual filesystem
        "/sys" # virtual filesystem
        "/dev" # virtual filesystem
        "/run" # runtime files
        "/tmp" # temporary files
        "/var/tmp" # temporary files
      ];
    };
  };
}

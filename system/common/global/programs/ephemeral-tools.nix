{self, ...}: {
  imports = [
    self.nixosModules.ephemeral-tools
  ];

  programs.ephemeral-tools = {
    enable = true;

    exclude-paths = [
      # https://wiki.archlinux.org/title/XDG_Base_Directory
      "/home/different/.steam" # using a full mount to persist this, rather than the impermanence module
      "/home/different/.local/share/Steam" # ditto the above comment ^
      "/home/different/Media"
      "/home/different/.vscode-oss" # seems to be data written by the vscode home-manager module
      "/home/different/.config/VSCodium" # some subfolders are persisted, but I should have everything I need now
      "/home/different/.config/fish" # can configure declaratively
      "/home/different/.local/share/applications/mimeapps.list" # can configure declaratively
      "/home/different/.pki" # seems to be from chromium, see above link. I haven't noticed anything wrong having this ephemeral

      "/boot" # non ephemeral
      "/run" # runtime files
      "/tmp" # temporary files
      "/var/tmp" # temporary files
    ];
  };
}

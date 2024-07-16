{
  nix-files.tools.ephemeral = {
    enable = true;

    exclude-paths = {
      home = [
        ".steam" # using a full mount to persist this, rather than the impermanence module
        ".local/share/Steam" # ditto the above comment ^
        ".config/VSCodium" # TODO check if i need this
        ".vscode-oss" # TODO check if i need this
      ];

      root = [
        "/nix"
        "/proc"
        "/sys"
        "/persist"
        "/run"
        "/dev"
        "/tmp"
        "/boot"
        "/var/tmp"
      ];
    };
  };
}

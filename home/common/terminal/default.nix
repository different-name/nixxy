{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./btop.nix
    ./fastfetch.nix
    ./fish.nix
    ./git.nix
    ./yazi.nix
  ];

  options.nix-files.terminal.enable = lib.mkEnableOption "Terminal packages";

  config = lib.mkIf config.nix-files.terminal.enable {
    home.packages = with pkgs; [
      imagemagick
      ffmpeg
      trashy
      ncdu
      aspell
      aspellDicts.en
      libqalculate
      sshfs
      magic-wormhole
      exiftool
      alejandra
      qmk
      yt-dlp
      zip
      unzip
      nvfetcher
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # qalculate
        ".config/qalculate"
        ".local/share/qalculate"
      ];
    };
  };
}

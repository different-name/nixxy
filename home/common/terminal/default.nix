{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./btop.nix
    ./fastfetch.nix
    ./fish.nix
    ./git.nix
    ./television.nix
    ./yazi.nix
  ];

  options.nix-files.terminal.enable = lib.mkEnableOption "Terminal packages";

  config = lib.mkIf config.nix-files.terminal.enable {
    home.packages = with pkgs; [
      self.packages.${pkgs.system}.mcuuid
      self.packages.${pkgs.system}.nt

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
      nix-melt
      nix-init
      nurl
      nix-output-monitor
    ];

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # nvfetcher
        ".local/share/nvfetcher"

        # qalculate
        ".config/qalculate"
        ".local/share/qalculate"
      ];
    };
  };
}

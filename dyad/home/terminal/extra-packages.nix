{
  lib,
  config,
  self',
  pkgs,
  ...
}:
{
  options.dyad.terminal.extra-packages.enable = lib.mkEnableOption "extra terminal packages";

  config = lib.mkIf config.dyad.terminal.extra-packages.enable {
    dyad.system.persistence.installPkgsWithPersistence = {
      # calculator
      libqalculate.dirs = [
        ".config/qalculate"
        ".local/share/qalculate"
      ];

      # fetch minecraft user uuids
      mcuuid.package = self'.packages.mcuuid;

      # generate nix sources for packages
      nvfetcher.dirs = [
        ".local/share/nvfetcher"
      ];
    };

    home.packages = with pkgs; [
      aspell # spell checker
      aspellDicts.en # aspell english dictionary
      bat # cat with syntax highlighting
      cocogitto # git toolbox
      ffmpeg # manipulate videos
      imagemagick # manipulate images
      just # command runner
      magic-wormhole # transfer files between computers
      ncdu # disk usage
      nix-init # generate package definitions
      nix-melt # flake.lock viewer
      nixfmt-tree # nixpkgs formatter
      nurl # generate fetcher expressions
      pv # pipe viewer, monitor data flow through pipe
      sshfs # mount remote directories over ssh
      trashy # move files to trash
      tree # directory listing
      unzip # unzip files
      yt-dlp # audio/video downloader
      zip # zip files
    ];
  };
}

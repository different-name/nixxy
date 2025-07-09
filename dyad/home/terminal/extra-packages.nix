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
    home.perpetual.default.packages = {
      # keep-sorted start block=yes newline_separated=yes
      # calculator
      libqalculate.dirs = [
        "$configHome/qalculate"
        "$dataHome/qalculate"
      ];

      # fetch minecraft user uuids
      mcuuid.package = self'.packages.mcuuid;

      # generate nix sources for packages
      nvfetcher.dirs = [
        "$dataHome/nvfetcher"
      ];
      # keep-sorted end
    };

    home.packages = with pkgs; [
      # keep-sorted start
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
      # keep-sorted end
    ];
  };
}

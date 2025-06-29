{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.nix-files.parts.terminal.extra-packages.enable =
    lib.mkEnableOption "extra terminal packages";

  config = lib.mkIf config.nix-files.parts.terminal.extra-packages.enable {
    home.packages =
      (with pkgs; [
        # applications
        libqalculate # calculator

        # file management
        ncdu # disk usage
        sshfs # mount remote directories over ssh
        magic-wormhole # transfer files between computers
        zip # zip files
        unzip # unzip files
        trashy # move files to trash

        # media
        imagemagick # manipulate images
        ffmpeg # manipulate videos
        yt-dlp # audio/video downloader

        # nix
        nixfmt-tree # nixpkgs formatter
        nvfetcher # generate nix sources for packages
        nix-melt # flake.lock viewer
        nix-init # generate package definitions
        nurl # generate fetcher expressions

        # misc
        aspell # spell checker
        aspellDicts.en # aspell english dictionary
        pv # pipe viewer, monitor data flow through pipe
        tree # directory listing
      ])
      ++ [
        inputs.self.packages.${pkgs.system}.mcuuid
      ];

    nix-files.parts.system.persistence = {
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

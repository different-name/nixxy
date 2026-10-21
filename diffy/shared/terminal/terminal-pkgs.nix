{
  bundleLib,
  self',
  lib,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "terminal" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    imports = lib.attrValues {
      # keep-sorted start block=yes newline_separated=yes
      # github cli
      gh = {
        home.packages = [ pkgs.gh ];
        keep.safe = {
          cacheDirs = [ "gh" ];
          configDirs = [ "gh" ];
        };
      };

      # git tui
      lazygit = {
        home.packages = [ pkgs.lazygit ];
        keep.safe.stateDirs = [ "lazygit" ];
      };

      # calculator
      libqalculate = {
        home.packages = [ pkgs.libqalculate ];
        keep.safe = {
          configDirs = [ "qalculate" ];
          dataDirs = [ "qalculate" ];
        };
      };

      nixxy-fmt.home.packages = [
        (pkgs.writeShellScriptBin "nixxy-fmt" ''
          exec ${lib.getExe self'.formatter} "$@"
        '')
      ];

      # audio/video downloader
      yt-dlp = {
        home.packages = [ pkgs.yt-dlp ];
        keep.safe.cacheDirs = [ "yt-dlp" ];
      };
      # keep-sorted end
    };

    home.packages = with pkgs; [
      # keep-sorted start block=yes
      bat # cat with syntax highlighting
      cocogitto # git toolbox
      ffmpeg # manipulate videos
      glow # pretty markdown renderer
      imagemagick # manipulate images
      jq # json parser
      magic-wormhole # transfer files between computers
      ncdu # disk usage
      nix-init # generate package definitions
      nix-melt # flake.lock viewer
      nix-output-monitor # pretty nix builds
      nixfmt-tree # nixpkgs formatter
      nurl # generate fetcher expressions
      pv # pipe viewer, monitor data flow through pipe
      screen # used for serial terminal
      sshfs # mount remote directories over ssh
      trashy # move files to trash
      tree # directory listing
      unzip # unzip files
      usbutils # tools for usb devices
      zip # zip files
      # keep-sorted end
    ];
  };
}

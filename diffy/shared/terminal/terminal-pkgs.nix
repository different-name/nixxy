{
  bundleLib,
  self',
  lib,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "terminal" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    keep.persist.packages = {
      # keep-sorted start block=yes newline_separated=yes
      nixxy-fmt.package = pkgs.writeShellScriptBin "nixxy-fmt" ''
        exec ${lib.getExe self'.formatter} "$@"
      '';

      # git tui
      lazygit.xdg.state.dirs."lazygit" = { };

      # calculator
      libqalculate = {
        xdg.config.dirs."qalculate" = { };
        xdg.data.dirs."qalculate" = { };
      };

      # audio/video downloader
      yt-dlp.xdg.cache.dirs."yt-dlp" = { };

      # github cli
      gh = {
        xdg.cache.dirs."gh" = { };
        xdg.config.dirs."gh" = { };
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

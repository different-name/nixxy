{
  bundleLib,
  self',
  lib,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "terminal" "extraPackages" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.perpetual.default.packages = {
        # keep-sorted start block=yes newline_separated=yes
        # video compression for discord (10 MB)
        ffmpeg4discord.package = self'.packages.ffmpeg4discord;

        nixxy-fmt.package = pkgs.writeShellScriptBin "nixxy-fmt" ''
          exec ${lib.getExe self'.formatter} "$@"
        '';

        # git tui
        lazygit.dirs = [
          "$stateHome/lazygit"
        ];

        # calculator
        libqalculate.dirs = [
          "$configHome/qalculate"
          "$dataHome/qalculate"
        ];
        # keep-sorted end
      };

      home.packages = with pkgs; [
        # keep-sorted start block=yes
        aspell # spell checker
        aspellDicts.en # aspell english dictionary
        bat # cat with syntax highlighting
        cocogitto # git toolbox
        ffmpeg # manipulate videos
        imagemagick # manipulate images
        jq # json parser
        just # command runner
        magic-wormhole # transfer files between computers
        ncdu # disk usage
        nix-init # generate package definitions
        nix-melt # flake.lock viewer
        nixfmt-tree # nixpkgs formatter
        nurl # generate fetcher expressions
        pv # pipe viewer, monitor data flow through pipe
        screen # used for serial terminal
        sshfs # mount remote directories over ssh
        trashy # move files to trash
        tree # directory listing
        unzip # unzip files
        usbutils # tools for usb devices
        yt-dlp # audio/video downloader
        zip # zip files
        # keep-sorted end
      ];
    };
}

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
      gh = {
        home.packages = [ pkgs.gh ];
        keep.safe = {
          cacheDirs = [ "gh" ];
          configDirs = [ "gh" ];
        };
      };

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
      imagemagick # manipulate images
      jq # json parser
      ncdu # disk usage
      nix-melt # flake.lock viewer
      nix-output-monitor # pretty nix builds
      nixfmt-tree # nixpkgs formatter
      pv # pipe viewer, monitor data flow through pipe
      screen # used for serial terminal
      sshfs # mount remote directories over ssh
      tree # directory listing
      unzip # unzip files
      usbutils # tools for usb devices
      zip # zip files
      # keep-sorted end
    ];
  };
}

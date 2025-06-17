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
        nixfmt-tree
        qmk
        yt-dlp
        zip
        unzip
        nvfetcher
        nix-melt
        nix-init
        nurl
        nix-output-monitor
        pv
        tree
      ])
      ++ (with inputs.self.packages.${pkgs.system}; [
        nt
        mcuuid
      ]);

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

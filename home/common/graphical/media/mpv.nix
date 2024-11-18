{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.media.mpv.enable = lib.mkEnableOption "mpv config";

  config = lib.mkIf config.nix-files.graphical.media.mpv.enable {
    programs.mpv.enable = true;

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/mpv"
      ];
    };
  };
}

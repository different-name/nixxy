{ lib, config, ... }:
{
  options.dyad.media.mpv.enable = lib.mkEnableOption "mpv config";

  config = lib.mkIf config.dyad.media.mpv.enable {
    programs.mpv.enable = true;

    dyad.system.persistence.dirs = [
      ".cache/mpv"
    ];
  };
}

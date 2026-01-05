{ lib, config, ... }:
{
  options.dyad.media.mpv.enable = lib.mkEnableOption "mpv config";

  config = lib.mkIf config.dyad.media.mpv.enable {
    programs.mpv = {
      enable = true;
      config = {
        # fix for discord stream audio capture
        ao = "pulse";
      };
    };

    home.perpetual.default.dirs = [
      "$cacheHome/mpv"
    ];
  };
}

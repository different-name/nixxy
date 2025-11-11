{ lib, config, ... }:
{
  options.dyad.profiles.graphical-extras.enable = lib.mkEnableOption "graphical-extras profile";

  config = lib.mkIf config.dyad.profiles.graphical-extras.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      hardware.ddcutil.enable = true;

      programs = {
        obs-studio.enable = true;
        steam.enable = true;
      };
      # keep-sorted end
    };

    hardware.openrazer.enable = true;
  };
}

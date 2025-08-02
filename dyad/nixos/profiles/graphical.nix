{ lib, config, ... }:
{
  options.dyad.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.dyad.profiles.graphical.enable {
    dyad = {
      profiles.graphical-minimal.enable = true;

      # keep-sorted start block=yes newline_separated=yes
      hardware.ddcutil.enable = true;

      programs = {
        # keep-sorted start
        obs-studio.enable = true;
        steam.enable = true;
        # keep-sorted end
      };
      # keep-sorted end
    };
  };
}

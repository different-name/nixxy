{ lib, config, ... }:
{
  options.dyad.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.dyad.profiles.graphical.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      desktop = {
        # keep-sorted start
        fonts.enable = true;
        hyprland.enable = true;
        qt.enable = true;
        uwsm.enable = true;
        xdg.enable = true;
        # keep-sorted end
      };

      hardware.ddcutil.enable = true;

      programs = {
        # keep-sorted start
        obs.enable = true;
        steam.enable = true;
        thunar.enable = true;
        # keep-sorted end
      };

      services.pipewire.enable = true;
      # keep-sorted end
    };

    hardware.graphics.enable = true;
  };
}

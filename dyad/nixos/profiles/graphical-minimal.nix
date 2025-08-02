{ lib, config, ... }:
{
  options.dyad.profiles.graphical-minimal.enable = lib.mkEnableOption "minimal graphical profile";

  config = lib.mkIf config.dyad.profiles.graphical-minimal.enable {
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

      programs.thunar.enable = true;

      services.pipewire.enable = true;

      style.catppuccin.enable = true;
      # keep-sorted end
    };

    hardware.graphics.enable = true;
  };
}

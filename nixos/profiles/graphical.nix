{
  lib,
  config,
  ...
}:
{
  options.nix-files.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.nix-files.profiles.graphical.enable {
    hardware.graphics.enable = true;

    nix-files.parts = {
      hardware.ddcutil.enable = true;

      desktop = {
        fonts.enable = true;
        hyprland.enable = true;
        qt.enable = true;
        uwsm.enable = true;
        xdg.enable = true;
      };

      programs = {
        obs.enable = true;
        steam.enable = true;
        thunar.enable = true;
      };

      services = {
        pipewire.enable = true;
      };
    };
  };
}

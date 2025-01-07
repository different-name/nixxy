{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.graphical.enable = lib.mkEnableOption "Graphical profile";

  config = lib.mkIf config.nix-files.profiles.graphical.enable {
    hardware.graphics.enable = true;

    nix-files = {
      programs = {
        fonts.enable = true;
        hyprland.enable = true;
        obs.enable = true;
        qt.enable = true;
        steam.enable = true;
        thunar.enable = true;
        uwsm.enable = true;
        xdg.enable = true;
      };

      services = {
        pipewire.enable = true;
      };
    };
  };
}

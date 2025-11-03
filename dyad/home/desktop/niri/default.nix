{
  lib,
  config,
  ...
}:
{
  options.dyad.desktop.niri.enable = lib.mkEnableOption "niri config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    xdg.configFile."niri/config.kdl" = {
      source = ./config.kdl;
      force = true;
    };
  };
}

{
  lib,
  config,
  ...
}:
{
  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
      };
    };
  };
}

{
  lib,
  config,
  inputs',
  ...
}:
{
  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs'.hyprland.packages.hyprland;
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    # hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

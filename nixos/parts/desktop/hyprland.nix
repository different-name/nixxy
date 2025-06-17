{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options.nix-files.parts.desktop.hyprland.enable = lib.mkEnableOption "Hyprland config";

  config = lib.mkIf config.nix-files.parts.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${pkgs.system}".hyprland;
      portalPackage = inputs.hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    };

    # hint electron apps to use wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

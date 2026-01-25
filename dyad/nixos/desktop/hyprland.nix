{
  lib,
  config,
  inputs,
  inputs',
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  hyprlandPkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
in
{
  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs'.hyprland.packages.hyprland;
      portalPackage = inputs'.hyprland.packages.xdg-desktop-portal-hyprland;
    };

    hardware.graphics.package = hyprlandPkgs.mesa;

    programs.uwsm.enable = true;

    environment = {
      # auto launch hyprland on tty1
      loginShellInit = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
        fi
      '';

      # hint electron apps to use wayland
      sessionVariables.NIXOS_OZONE_WL = 1;
    };
  };
}

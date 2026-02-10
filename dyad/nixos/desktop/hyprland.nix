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

      sessionVariables = {
        # hint electron apps to use wayland
        NIXOS_OZONE_WL = 1;

        # required for UWSM to find hyprland
        # TODO remove after fixed: https://github.com/NixOS/nixpkgs/issues/485123
        XDG_DATA_DIRS = [
          "${config.programs.hyprland.package}/share"
        ];
      };
    };
  };
}

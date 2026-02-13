{
  lib,
  config,
  inputs,
  inputs',
  self,
  ...
}:
{
  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    nixos =
      { config, pkgs, ... }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        hyprlandPkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system};
      in
      {
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

    hm =
      { osConfig, pkgs, ... }:
      {
        imports = [
          self.homeModules.xdgDesktopPortalHyprland
        ];

        config = {
          wayland.windowManager.hyprland = {
            enable = true;
            package = null;
            portalPackage = null;

            systemd = {
              enable = !osConfig.programs.uwsm.enable; # conflicts with uwsm
              variables = [ "--all" ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
            };

            xwayland.enable = true;

            settings.exec-once = [
              "${lib.getExe pkgs.wl-clip-persist} --clipboard regular"
            ];
          };

          services.hyprpolkitagent.enable = true;

          home.packages = [
            pkgs.hyprpicker
            pkgs.grimblast
          ];

          home.perpetual.default.dirs = [
            "$cacheHome/hyprland"
            "$dataHome/hyprland"
          ];
        };
      };
  };
}

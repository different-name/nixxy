{
  bundleLib,
  lib,
  inputs,
  inputs',
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "desktop" "hyprland" ] {
  nixos =
    { pkgs, ... }:
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
            exec uwsm start -e -D Hyprland hyprland.desktop
          fi
        '';

        # hint electron apps to use wayland
        sessionVariables.NIXOS_OZONE_WL = 1;
      };
    };

  home-manager =
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
}

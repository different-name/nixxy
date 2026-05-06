{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "mako" ] {
  home-manager =
    { config, pkgs, ... }:
    let
      catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
      themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
      getColor = color: lib.removePrefix "#" themeColors.${color}.hex;

      borderColor = getColor "green";
      hyprlandCfg = config.wayland.windowManager.hyprland;
    in
    {
      services.mako = {
        enable = true;
        settings = {
          "border-color" = lib.mkForce "#${borderColor}";
          "border-radius" = hyprlandCfg.settings.decoration.rounding;

          "mode=do-not-disturb" = {
            invisible = 1;
          };
        };
      };

      home.packages = [
        (pkgs.writeShellApplication {
          name = "mako-dnd";

          runtimeInputs = [
            config.services.mako.package
            hyprlandCfg.package
          ];

          text = ''
            if makoctl mode | grep -q '\<do-not-disturb\>'; then
                makoctl mode -r do-not-disturb
                hyprctl notify -1 1000 "rgb(${borderColor})" "Notifications Shown"
            else
                makoctl mode -a do-not-disturb
                hyprctl notify -1 1000 "rgb(${borderColor})" "Notifications Hidden"
            fi
          '';
        })
      ];
    };
}

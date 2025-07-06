{
  lib,
  config,
  pkgs,
  ...
}:
let
  catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  borderColor = themeColors.${config.catppuccin.accent}.hex;

  hyprlandCfg = config.wayland.windowManager.hyprland;
in
{
  options.dyad.desktop.mako.enable = lib.mkEnableOption "mako config";

  config = lib.mkIf config.dyad.desktop.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        "border-color" = lib.mkForce "${borderColor}";
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
          hyprlandCfg.package
          config.services.mako.package
        ];

        text = ''
          if makoctl mode | grep -q '\<do-not-disturb\>'; then
              makoctl mode -r do-not-disturb
              hyprctl notify -1 5000 "rgb(${borderColor})" "Notifications Shown"
          else
              makoctl mode -a do-not-disturb
              hyprctl notify -1 5000 "rgb(${borderColor})" "Notifications Hidden"
          fi
        '';
      })
    ];
  };
}

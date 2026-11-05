{
  bundleLib,
  config,
  lib,
  ...
}:
let
  inherit (config.dyad.desktop.hyprland) rounding;
  withHyprland = config.dyad.desktop.hyprland.enable;
in
bundleLib.mkEnableModule [ "dyad" "desktop" "mako" ] {
  home-manager =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (config.dyad) palette;
      borderColor = lib.removePrefix "#" palette.green.hex;
    in
    {
      # catppuccin's include sorts after the settings and would override the translucent background
      catppuccin.mako.enable = false;

      services.mako = {
        enable = true;
        settings = {
          "background-color" = "${palette.base.hex}d9";
          "border-color" = palette.${config.catppuccin.accent}.hex;
          "border-radius" = rounding;
          "progress-color" = "over ${palette.surface0.hex}";
          "text-color" = palette.text.hex;

          "mode=do-not-disturb" = {
            invisible = 1;
          };

          "urgency=high" = {
            "border-color" = palette.peach.hex;
          };
        };
      };

      wayland.windowManager.hyprland.settings.layer_rule = lib.mkIf withHyprland (
        lib.singleton {
          name = "mako";
          match.namespace = "^notifications$";
          blur = true;
          ignore_alpha = 0.5;
        }
      );

      # toggles with a hyprctl notification, bound in hyprland
      home.packages = lib.mkIf withHyprland (
        lib.singleton (
          pkgs.writeShellApplication {
            name = "mako-dnd";

            runtimeInputs = [
              config.services.mako.package
              osConfig.programs.hyprland.package
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
          }
        )
      );
    };
}

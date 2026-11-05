{ lib, config, ... }:
let
  inherit (config.dyad.desktop.hyprland) rounding;
in
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager =
      { config, ... }:
      let
        palette = config.dyad.palette;
        activeColor = lib.removePrefix "#" palette.green.hex;
        inactiveColor = lib.removePrefix "#" palette.mantle.hex;
        alternateColor = lib.removePrefix "#" palette.mauve.hex;
      in
      {
        xdg.configFile."hypr/hyprtoolkit.conf".text =
          lib.generators.toKeyValue { } (
            lib.mapAttrs (_: c: "rgb(${lib.removePrefix "#" palette.${c}.hex})") {
              background = "base";
              base = "surface0";
              alternate_base = "surface1";
              text = "text";
              bright_text = "rosewater";
              link_text = "blue";
              accent = config.catppuccin.accent;
              accent_secondary = "lavender";
            }
          )
          + ''
            rounding_large=${toString rounding}
            rounding_small=${toString (rounding / 2)}
          '';

        wayland.windowManager.hyprland.settings = {
          config = {
            general = {
              gaps_in = 3;
              gaps_out = 6;
              col = {
                active_border = "rgb(${activeColor})";
                inactive_border = "rgba(${inactiveColor}88)";
              };
            };

            decoration = {
              inherit rounding;
              shadow = {
                range = 8;
                render_power = 3;
                color = "rgba(00000055)";
              };
              dim_inactive = false;
            };

            animations.enabled = true;

            group = {
              col = {
                border_active = "rgb(${alternateColor})";
                border_inactive = "rgba(${inactiveColor}88)";
                border_locked_active = "rgb(${activeColor})";
                border_locked_inactive = "rgba(${inactiveColor}88)";
              };
              groupbar = {
                height = 6;
                render_titles = false;
                col = {
                  active = "rgb(${alternateColor})";
                  inactive = "rgb(${inactiveColor})";
                  locked_active = "rgb(${activeColor})";
                  locked_inactive = "rgb(${inactiveColor})";
                };
              };
            };
          };

          animation = [
            {
              leaf = "border";
              enabled = true;
              speed = 2;
              bezier = "default";
            }
            {
              leaf = "fade";
              enabled = true;
              speed = 4;
              bezier = "default";
            }
            {
              leaf = "windows";
              enabled = true;
              speed = 3;
              bezier = "default";
              style = "popin 80%";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 2;
              bezier = "default";
              style = "slide";
            }
          ];
        };
      };
  };
}

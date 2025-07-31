{ lib, config, ... }:
let
  catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  getColor = color: themeColors.${color}.hex;
  accentColor = getColor "mauve";
in
{
  options.dyad.terminal.zellij.enable = lib.mkEnableOption "zellij config";

  config = lib.mkIf config.dyad.terminal.zellij.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;

      settings = {
        theme = "catppuccin-mocha-custom";
        show_startup_tips = false;
      };

      themes.catppuccin-mocha-custom.themes.catppuccin-mocha-custom = {
        text_unselected = {
          base = getColor "text";
          background = getColor "mantle";
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        text_selected = {
          base = getColor "text";
          background = getColor "surface2";
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        ribbon_selected = {
          base = getColor "mantle";
          background = accentColor;
          emphasis_0 = getColor "mantle";
          emphasis_1 = getColor "rosewater";
          emphasis_2 = getColor "pink";
          emphasis_3 = getColor "blue";
        };

        ribbon_unselected = {
          base = getColor "subtext1";
          background = getColor "surface0";
          emphasis_0 = accentColor;
          emphasis_1 = getColor "surface0";
          emphasis_2 = getColor "blue";
          emphasis_3 = getColor "pink";
        };

        table_title = {
          base = accentColor;
          background = 0;
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        table_cell_selected = {
          base = getColor "text";
          background = getColor "surface2";
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        table_cell_unselected = {
          base = getColor "text";
          background = getColor "mantle";
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        list_selected = {
          base = getColor "text";
          background = getColor "surface2";
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        list_unselected = {
          base = getColor "text";
          background = getColor "mantle";
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = accentColor;
          emphasis_3 = getColor "pink";
        };

        frame_selected = {
          base = accentColor;
          background = 0;
          emphasis_0 = getColor "rosewater";
          emphasis_1 = getColor "sky";
          emphasis_2 = getColor "pink";
          emphasis_3 = 0;
        };

        frame_highlight = {
          base = getColor "rosewater";
          background = 0;
          emphasis_0 = getColor "pink";
          emphasis_1 = getColor "rosewater";
          emphasis_2 = getColor "rosewater";
          emphasis_3 = getColor "rosewater";
        };

        exit_code_success = {
          base = accentColor;
          background = 0;
          emphasis_0 = getColor "sky";
          emphasis_1 = getColor "mantle";
          emphasis_2 = getColor "pink";
          emphasis_3 = getColor "blue";
        };

        exit_code_error = {
          base = getColor "red";
          background = 0;
          emphasis_0 = getColor "yellow";
          emphasis_1 = 0;
          emphasis_2 = 0;
          emphasis_3 = 0;
        };

        multiplayer_user_colors = {
          player_1 = getColor "pink";
          player_2 = getColor "blue";
          player_3 = 0;
          player_4 = getColor "yellow";
          player_5 = getColor "sky";
          player_6 = 0;
          player_7 = getColor "red";
          player_8 = 0;
          player_9 = 0;
          player_10 = 0;
        };
      };
    };

    home.perpetual.default.dirs = [
      "$cacheHome/zellij"
    ];
  };
}

{ lib, config, ... }:
let
  catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  accentColor = themeColors."mauve".hex;
in
{
  options.dyad.terminal.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.dyad.terminal.fish.enable {
    programs.fish = {
      enable = true;

      shellInit = ''
        set -U fish_color_cwd "${accentColor}"
        set -U fish_color_user "${accentColor}"
      '';
    };

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$cacheHome/fish"
      "$dataHome/fish"
      # keep-sorted end
    ];
  };
}

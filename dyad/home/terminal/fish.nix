{ lib, config, ... }:
let
  catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  accentColor = themeColors.${config.catppuccin.accent}.hex;
in
{
  options.dyad.terminal.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.dyad.terminal.fish.enable {
    programs.fish = {
      enable = true;

      shellInit = ''
        set -U fish_color_cwd "${accentColor}"
        set -U fish_color_user "${accentColor}"
        ${if config.programs.fastfetch.enable then "fastfetch && echo" else ""}
      '';

      functions = {
        # wrapper for yazi https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
        yy = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };
    };

    dyad.system.persistence = {
      directories = [
        ".local/share/fish"
        ".cache/fish"
      ];
    };
  };
}

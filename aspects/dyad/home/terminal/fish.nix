{ lib, config, ... }:
let
  catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  accentColor = themeColors."mauve".hex;

  promptStr = "echo -n -s (prompt_login)' '";
  nixShellStr = ''(test "$IN_NIX_SHELL" = 1; and echo -n '+ ')'';

  fishPrompt =
    config.programs.fish.package + /share/fish/functions/fish_prompt.fish
    |> builtins.readFile
    |> lib.replaceString promptStr "${promptStr} ${nixShellStr}";
in
{
  options.dyad.terminal.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.dyad.terminal.fish.enable {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        # disable greeting
        set fish_greeting

        set -U fish_color_cwd "${accentColor}"
        set -U fish_color_user "${accentColor}"

        ${fishPrompt}
      '';

      functions = {
        "," = ''
          if test (count $argv) -lt 1
            echo "Usage: + installable args..."
            return 1
          end

          if string match -q '*#*' -- $argv[1]
            set installable $argv[1]
          else
            set installable "nixpkgs#$argv[1]"
          end

          NIXPKGS_ALLOW_UNFREE=1 nix run $installable --impure -- $argv[2..-1]
        '';

        "+" = ''
          if test (count $argv) -lt 1
            echo "Usage: + installables..."
            return 1
          end

          set args
          for arg in $argv
            if string match -q '*#*' -- $arg
              set args $args $arg
            else
              set args $args "nixpkgs#$arg"
            end
          end

          NIXPKGS_ALLOW_UNFREE=1 IN_NIX_SHELL=1 nix shell nixpkgs#fish $args --impure --command fish
        '';
      };
    };

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$cacheHome/fish"
      "$dataHome/fish"
      # keep-sorted end
    ];
  };
}

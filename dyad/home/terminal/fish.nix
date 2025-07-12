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

      interactiveShellInit = ''
        # launch tmux
        if status is-interactive
        and not set -q TMUX
          exec ${lib.getExe config.programs.tmux.package}
        end

        # disable greeting
        set fish_greeting

        set -U fish_color_cwd "${accentColor}"
        set -U fish_color_user "${accentColor}"
      '';

      # tmux workaround https://github.com/fish-shell/fish-shell/issues/11538
      binds."ctrl-h".command = "backward-kill-word";
    };

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$cacheHome/fish"
      "$dataHome/fish"
      # keep-sorted end
    ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  accentColor = themeColors."mauve".hex;
in
{
  options.dyad.programs.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.dyad.programs.fish.enable {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set -U fish_color_cwd "${accentColor}"
        set -U fish_color_user "${accentColor}"

        # launch tmux
        if status is-interactive
        and not set -q TMUX
            exec ${lib.getExe config.programs.tmux.package}
        end

        set fish_greeting # disable greeting

        # https://github.com/fish-shell/fish-shell/issues/11538
        bind ctrl-h backward-kill-word
      '';
    };

    # use fish as shell https://nixos.wiki/wiki/Fish
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
        fi
      '';
    };
  };
}

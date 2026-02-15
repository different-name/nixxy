{ lib, config, ... }:
{
  options.dyad.terminal.fish.enable = lib.mkEnableOption "fish as default shell";

  config = lib.mkIf config.dyad.terminal.fish.enable {
    nixos =
      { pkgs, ... }:
      {
        programs = {
          fish.enable = true;

          # use fish as shell https://nixos.wiki/wiki/Fish
          bash.interactiveShellInit = ''
            if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
            then
              shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
              exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
            fi
          '';
        };
      };

    home-manager =
      { config, ... }:
      let
        catppuccinPalette = lib.importJSON (config.catppuccin.sources.palette + /palette.json);
        themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
        accentColor = themeColors."mauve".hex;
      in
      {
        programs.fish = {
          enable = true;

          interactiveShellInit = ''
            # disable greeting
            set fish_greeting

            set -U fish_color_cwd "${accentColor}"
            set -U fish_color_user "${accentColor}"
          '';
        };

        home.perpetual.default.dirs = [
          "$cacheHome/fish"
          "$dataHome/fish"
        ];
      };
  };
}

{
  lib,
  config,
  ...
}: {
  options.nix-files.terminal.fish.enable = lib.mkEnableOption "Fish config";

  config = lib.mkIf config.nix-files.terminal.fish.enable {
    programs.fish = {
      enable = true;
      catppuccin.enable = lib.mkIf config.catppuccin.enable false;

      shellInit = ''
        set -U fish_color_cwd red
        set -U fish_color_user red
        ${
          if config.programs.fastfetch.enable
          then "fastfetch"
          else ""
        }
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

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".local/share/fish"
      ];
    };
  };
}

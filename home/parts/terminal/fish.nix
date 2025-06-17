{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.terminal.fish.enable = lib.mkEnableOption "Fish config";

  config = lib.mkIf config.nix-files.parts.terminal.fish.enable {
    programs.fish = {
      enable = true;

      shellInit = ''
        set -U fish_color_cwd red
        set -U fish_color_user red
        ${
          if config.programs.fastfetch.enable
          then "fastfetch && echo"
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

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".local/share/fish"
        ".cache/fish"
      ];
    };
  };
}

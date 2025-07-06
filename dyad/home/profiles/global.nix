{ lib, config, ... }:
{
  options.dyad.profiles.global.enable = lib.mkEnableOption "global profile";

  config = lib.mkIf config.dyad.profiles.global.enable {
    programs.fd.enable = true;

    dyad = {
      system = {
        persistence = {
          enable = true;

          directories = [
            "nix-files"
            ".terminfo"
            ".local/share/Trash"
          ];
        };
      };

      terminal = {
        extra-packages.enable = true;

        btop.enable = true;
        fastfetch.enable = true;
        fish.enable = true;
        git.enable = true;
        television.enable = true;
        yazi.enable = true;
      };

      theming = {
        catppuccin.enable = true;
      };
    };
  };
}

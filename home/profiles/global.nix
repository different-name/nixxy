{
  lib,
  config,
  ...
}:
{
  options.nix-files.profiles.global.enable = lib.mkEnableOption "global profile";

  config = lib.mkIf config.nix-files.profiles.global.enable {
    programs.fd.enable = true;

    nix-files.parts = {
      system = {
        home-manager.enable = true;

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

{ lib, config, ... }:
{
  options.dyad.profiles.terminal.enable = lib.mkEnableOption "terminal profile";

  config = lib.mkIf config.dyad.profiles.terminal.enable {
    programs.fd.enable = true;

    dyad = {
      terminal = {
        extra-packages.enable = true;

        btop.enable = true;
        fastfetch.enable = true;
        fish.enable = true;
        git.enable = true;
        television.enable = true;
        yazi.enable = true;
      };

      theming.catppuccin.enable = true;
    };
  };
}

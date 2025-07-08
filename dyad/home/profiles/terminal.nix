{ lib, config, ... }:
{
  options.dyad.profiles.terminal.enable = lib.mkEnableOption "terminal profile";

  config = lib.mkIf config.dyad.profiles.terminal.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      terminal = {
        # keep-sorted start
        btop.enable = true;
        dyad.enable = true;
        extra-packages.enable = true;
        fastfetch.enable = true;
        fish.enable = true;
        git.enable = true;
        television.enable = true;
        yazi.enable = true;
        # keep-sorted end
      };

      style.catppuccin.enable = true;
      # keep-sorted end
    };

    programs.fd.enable = true;
  };
}

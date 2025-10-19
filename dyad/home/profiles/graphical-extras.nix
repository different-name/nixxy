{ lib, config, ... }:
{
  options.dyad.profiles.graphical-extras.enable = lib.mkEnableOption "graphical-extras profile";

  config = lib.mkIf config.dyad.profiles.graphical-extras.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      applications = {
        # keep-sorted start
        applications-pkgs.enable = true;
        blender.enable = true;
        discord.enable = true;
        obsidian.enable = true;
        # keep-sorted end
      };

      games = {
        # keep-sorted start
        games-pkgs.enable = true;
        steam.enable = true;
        # keep-sorted end
      };

      media = {
        # keep-sorted start
        goxlr-utility.enable = true;
        media-pkgs.enable = true;
        # keep-sorted end
      };

      style.catppuccin.enable = true;
      # keep-sorted end
    };
  };
}

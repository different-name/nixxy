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
        games-pkgs.enable = true;
        steam.enable = true;
      };

      media = {
        goxlr-utility.enable = true;
        media-pkgs.enable = true;
      };

      style.catppuccin.enable = true;
      # keep-sorted end
    };
  };
}

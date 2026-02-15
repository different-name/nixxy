{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "graphical-extras" ] {
  dyad = {
    # keep-sorted start block=yes newline_separated=yes
    applications = {
      # keep-sorted start
      applications-pkgs.enable = true;
      blender.enable = true;
      discord.enable = true;
      obs-studio.enable = true;
      # keep-sorted end
    };

    games = {
      games-pkgs.enable = true;
      steam.enable = true;
    };

    hardware.ddcutil.enable = true;

    media = {
      goxlr-utility.enable = true;
      media-pkgs.enable = true;
    };

    style.catppuccin.enable = true;
    # keep-sorted end
  };
}

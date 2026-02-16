{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "graphical-extras" ] {
  dyad = {
    # keep-sorted start block=yes newline_separated=yes
    applications = {
      # keep-sorted start
      applications-pkgs.enable = true;
      discord.enable = true;
      obs-studio.enable = true;
      # keep-sorted end
    };

    games = {
      # keep-sorted start
      games-pkgs.enable = true;
      steam.enable = true;
      vrcx.enable = true;
      # keep-sorted end
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

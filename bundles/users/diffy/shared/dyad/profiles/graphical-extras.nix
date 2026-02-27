{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "graphical-extras" ] {
  dyad = {
    # keep-sorted start block=yes newline_separated=yes
    applications = {
      # keep-sorted start
      discord.enable = true;
      extraPackages.enable = true;
      obs-studio.enable = true;
      # keep-sorted end
    };

    games = {
      # keep-sorted start
      extraPackages.enable = true;
      steam.enable = true;
      vrcx.enable = true;
      # keep-sorted end
    };

    hardware.ddcutil.enable = true;

    media = {
      goxlr-utility.enable = true;
      extraPackages.enable = true;
    };

    style.catppuccin.enable = true;
    # keep-sorted end
  };
}

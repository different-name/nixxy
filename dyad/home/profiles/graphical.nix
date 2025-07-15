{ lib, config, ... }:
{
  options.dyad.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.dyad.profiles.graphical.enable {
    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      applications = {
        # keep-sorted start
        blender.enable = true;
        discord.enable = true;
        extra-packages.enable = true;
        firefox.enable = true;
        kitty.enable = true;
        obsidian.enable = true;
        # unity.enable = true; # TODO disabled until https://github.com/NixOS/nixpkgs/issues/418451 is closed
        # keep-sorted end
      };

      desktop = {
        # keep-sorted start
        anyrun.enable = true;
        extra-packages.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
        mako.enable = true;
        qt.enable = true;
        xdg.enable = true;
        # keep-sorted end
      };

      games = {
        # keep-sorted start
        extra-packages.enable = true;
        steam.enable = true;
        # keep-sorted end
      };

      media = {
        # keep-sorted start
        extra-packages.enable = true;
        goxlr-utility.enable = true;
        imv.enable = true;
        mpv.enable = true;
        # keep-sorted end
      };
      # keep-sorted end
    };

    # keep-sorted start
    gtk.enable = true;
    programs.mpv.enable = true;
    programs.zathura.enable = true;
    services.playerctld.enable = true;
    # keep-sorted end

    home.perpetual.default.dirs = [
      # keep-sorted start
      "Code"
      "Documents"
      "Downloads"
      "Media"
      "Pictures"
      "Videos"
      # keep-sorted end
    ];
  };
}

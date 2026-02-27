{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "graphical" ] {
  dyad = {
    # keep-sorted start block=yes newline_separated=yes
    applications = {
      # keep-sorted start
      kitty.enable = true;
      librewolf.enable = true;
      thunar.enable = true;
      vscodium.enable = true;
      # keep-sorted end
    };

    desktop = {
      # keep-sorted start
      desktop-pkgs.enable = true;
      fonts.enable = true;
      hexecute.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
      qt.enable = true;
      vicinae.enable = true;
      xdg.enable = true;
      # keep-sorted end
    };

    media = {
      imv.enable = true;
      mpv.enable = true;
    };

    services.pipewire.enable = true;

    style.catppuccin.enable = true;
    # keep-sorted end
  };

  nixos.hardware.graphics.enable = true;

  home-manager = {
    gtk.enable = true;
    services.playerctld.enable = true;

    home.perpetual.default.dirs = [
      # keep-sorted start
      "Code"
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"
      # keep-sorted end
    ];
  };
}

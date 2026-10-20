{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "graphical" ] {
  dyad = lib.mkDefault {
    profiles.workstation.enable = true;

    # keep-sorted start block=yes newline_separated=yes
    applications = {
      # keep-sorted start
      firefox.enable = true;
      kitty.enable = true;
      thunar.enable = true;
      vscodium.enable = true;
      # keep-sorted end
    };

    desktop = {
      # keep-sorted start
      brightness.enable = true;
      extraPackages.enable = true;
      fonts.enable = true;
      gtk.enable = true;
      hexecute.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
      qt.enable = true;
      swayosd.enable = true;
      vicinae.enable = true;
      xdg.enable = true;
      # keep-sorted end
    };

    media = {
      imv.enable = true;
      mpv.enable = true;
    };

    services.pipewire.enable = true;

    # keep-sorted end
  };

  # udev rules for flashing
  nixos.hardware.keyboard.qmk.enable = true;

  home-manager.services.playerctld.enable = true;
}

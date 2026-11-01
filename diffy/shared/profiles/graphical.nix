{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "graphical" ] {
  dyad = lib.mkDefault {
    profiles.workstation.enable = true;

    # keep-sorted start block=yes newline_separated=yes
    applications = {
      # keep-sorted start block=yes
      bitwarden = {
        autoStart = true;
        enable = true;
      };
      discord = {
        autoStart = true;
        enable = true;
      };
      extraPackages.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      obs-studio.enable = true;
      signal-desktop = {
        autoStart = true;
        enable = true;
      };
      spotify.enable = true;
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
      hyprland.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
      qpwgraph.enable = true;
      qt.enable = true;
      swayosd.enable = true;
      vicinae.enable = true;
      xdg.enable = true;
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
      # keep-sorted start
      extraPackages.enable = true;
      imv.enable = true;
      mpv.enable = true;
      # keep-sorted end
    };

    services = {
      # keep-sorted start
      gnome-keyring.enable = true;
      pipewire.enable = true;
      # keep-sorted end
    };
    # keep-sorted end
  };

  # udev rules for flashing
  nixos.hardware.keyboard.qmk.enable = true;

  home-manager.services.playerctld.enable = true;
}

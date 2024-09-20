{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.graphical.enable = lib.mkEnableOption "Graphical profile";

  config = lib.mkIf config.nix-files.profiles.graphical.enable {
    # programs
    programs.mpv.enable = true;
    programs.zathura.enable = true;

    # services
    services.playerctld.enable = true;

    # modules
    nix-files = {
      graphical = {
        games = {
          enable = true; # games packages
          steam.enable = true;
        };

        media = {
          enable = true; # media packages
          imv.enable = true;
          obs.enable = true;
        };

        meta = {
          gtk.enable = true;
          qt.enable = true;
          xdg.enable = true;
        };

        util = {
          enable = true; # util packages
          kitty.enable = true;
          unity.enable = true;
          vscodium.enable = true;
        };

        office.enable = true; # office packages

        wayland = {
          enable = true; # wayland packages
          hyprland.enable = true;
          hyprlock.enable = true;
          rofi.enable = true;
        };
      };

      services = {
        hyprpaper.enable = true;
        mako.enable = true;
      };
    };

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # home folders
        "code"
        "documents"
        "downloads"
        "pictures"
        "videos"
      ];
    };
  };
}

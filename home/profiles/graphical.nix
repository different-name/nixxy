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

    # meta
    gtk.enable = true;

    # modules
    nix-files = {
      graphical = {
        games = {
          enable = true; # games packages
          discord.enable = true;
          steam.enable = true;
        };

        media = {
          enable = true; # media packages
          imv.enable = true;
          mpv.enable = true;
          obs.enable = true;
        };

        meta = {
          qt.enable = true;
          xdg.enable = true;
        };

        util = {
          enable = true; # util packages
          blender.enable = true;
          firefox.enable = true;
          kitty.enable = true;
          summary.enable = true;
          unity.enable = true;
          vscodium.enable = true;
        };

        wayland = {
          enable = true; # wayland packages
          anyrun.enable = true;
          hyprland.enable = true;
          hyprlock.enable = true;
        };
      };

      services = {
        hyprpaper.enable = true;
        mako.enable = true;
      };
    };

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # home folders
        "Code"
        "Documents"
        "Downloads"
        "Pictures"
        "Videos"
        "Media"
      ];
    };
  };
}

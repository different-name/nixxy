{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.graphical.enable = lib.mkEnableOption "Graphical profile";

  config = lib.mkIf config.nix-files.profiles.graphical.enable {
    programs.mpv.enable = true;
    programs.zathura.enable = true;

    services.playerctld.enable = true;

    nix-files = {
      graphical = {
        games.steam.enable = true;

        media = {
          imv.enable = true;
          obs.enable = true;
        };

        meta = {
          gtk.enable = true;
          qt.enable = true;
          xdg.enable = true;
        };

        util = {
          kitty.enable = true;
          unity.enable = true;
          vscodium.enable = true;
        };

        wayland = {
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
  };
}

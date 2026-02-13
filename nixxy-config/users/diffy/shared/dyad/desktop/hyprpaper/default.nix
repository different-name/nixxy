{ lib, config, ... }:
{
  options.dyad.desktop.hyprpaper.enable = lib.mkEnableOption "hyprpaper config";

  config = lib.mkIf config.dyad.desktop.hyprpaper.enable {
    hm.services.hyprpaper = {
      enable = true;

      settings.wallpaper = lib.singleton {
        monitor = "";
        path = toString ./wallpaper.jpg;
      };
    };
  };
}

{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "hyprpaper" ] {
  home-manager.services.hyprpaper = {
    enable = true;

    settings = {
      wallpaper = lib.singleton {
        monitor = "";
        path = toString ./wallpaper.jpg;
      };

      splash = false;
    };
  };
}

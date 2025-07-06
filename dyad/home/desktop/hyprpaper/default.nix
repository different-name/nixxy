{
  lib,
  config,
  inputs',
  ...
}:
let
  wallpaperImg = ./wallpaper.jpg;
in
{
  options.dyad.desktop.hyprpaper.enable = lib.mkEnableOption "hyprpaper config";

  config = lib.mkIf config.dyad.desktop.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = inputs'.hyprpaper.packages.default;

      settings = {
        preload = [ "${wallpaperImg}" ];
        wallpaper = [ ",${wallpaperImg}" ];
      };
    };
  };
}

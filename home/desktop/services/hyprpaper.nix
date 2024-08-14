{
  pkgs,
  inputs,
  ...
}: let
  wallpaperImg = ../assets/wallpaper.jpg;
in {
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;

    settings = {
      preload = ["${wallpaperImg}"];
      wallpaper = [",${wallpaperImg}"];
    };
  };
}

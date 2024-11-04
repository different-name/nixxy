{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  wallpaperImg = ./wallpaper.jpg;
in {
  options.nix-files.services.hyprpaper.enable = lib.mkEnableOption "Hyprpaper config";

  config = lib.mkIf config.nix-files.services.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.default;

      settings = {
        preload = ["${wallpaperImg}"];
        wallpaper = [",${wallpaperImg}"];
      };
    };
  };
}

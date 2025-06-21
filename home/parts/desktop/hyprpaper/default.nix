{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  wallpaperImg = ./wallpaper.jpg;
in
{
  options.nix-files.parts.desktop.hyprpaper.enable = lib.mkEnableOption "hyprpaper config";

  config = lib.mkIf config.nix-files.parts.desktop.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.default;

      settings = {
        preload = [ "${wallpaperImg}" ];
        wallpaper = [ ",${wallpaperImg}" ];
      };
    };
  };
}

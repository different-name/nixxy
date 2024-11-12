{
  lib,
  config,
  pkgs,
  inputs,
  osConfig,
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

    wayland.windowManager.hyprland.settings.exec-once = let
      hyprpaper = config.services.hyprpaper.package;
    in [
      (
        if osConfig.programs.uwsm.enable
        then "uwsm app -- ${hyprpaper}/bin/hyprpaper"
        else "${hyprpaper}/bin/hyprpaper"
      )
    ];
  };
}

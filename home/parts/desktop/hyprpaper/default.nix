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
  options.nix-files.parts.desktop.hyprpaper.enable = lib.mkEnableOption "Hyprpaper config";

  config = lib.mkIf config.nix-files.parts.desktop.hyprpaper.enable {
    services.hyprpaper = {
      enable = true;
      package = inputs.hyprpaper.packages.${pkgs.system}.default;

      settings = {
        preload = ["${wallpaperImg}"];
        wallpaper = [",${wallpaperImg}"];
      };
    };

    wayland.windowManager.hyprland.settings.exec-once = let
      uwsmEnabled = osConfig.programs.uwsm.enable;
      hyprpaperPath = lib.getExe config.services.hyprpaper.package;
    in [
      "${lib.optionalString uwsmEnabled "uwsm app -- "}${hyprpaperPath}"
    ];
  };
}

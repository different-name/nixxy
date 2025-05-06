{
  lib,
  config,
  ...
}: let
  hyprlandCfg = config.wayland.windowManager.hyprland;
in {
  options.nix-files.services.mako.enable = lib.mkEnableOption "Mako config";

  config = lib.mkIf config.nix-files.services.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        "border-color" = lib.mkForce "#ed507c";
        "border-radius" = hyprlandCfg.settings.decoration.rounding;
      };
    };
  };
}

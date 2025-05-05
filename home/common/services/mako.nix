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
      borderColor = lib.mkForce "#ed507c";
      borderRadius = hyprlandCfg.settings.decoration.rounding;
    };
  };
}

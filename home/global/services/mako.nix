{lib, config, ...}: let
  hyprlandCfg = config.wayland.windowManager.hyprland;
in {
  services.mako = {
    enable = true;
    borderColor = lib.mkForce "#ed507c";
    borderRadius = hyprlandCfg.settings.decoration.rounding;
  };
}

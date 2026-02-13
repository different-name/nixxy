{ lib, config, ... }:
{
  options.dyad.desktop.hyprlock.enable = lib.mkEnableOption "hyprlock config";

  config = lib.mkIf config.dyad.desktop.hyprlock.enable {
    home-manager.programs.hyprlock = {
      enable = true;

      settings = {
        animations.enabled = false;
      };
    };
  };
}

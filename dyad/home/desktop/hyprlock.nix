{
  lib,
  config,
  inputs',
  ...
}:
{
  options.dyad.desktop.hyprlock.enable = lib.mkEnableOption "hyprlock config";

  config = lib.mkIf config.dyad.desktop.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      package = inputs'.hyprlock.packages.hyprlock;

      settings = {
        animations.enabled = false;
      };
    };
  };
}

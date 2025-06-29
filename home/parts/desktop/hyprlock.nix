{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.nix-files.parts.desktop.hyprlock.enable = lib.mkEnableOption "hyprlock config";

  config = lib.mkIf config.nix-files.parts.desktop.hyprlock.enable {
    programs.hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

      settings = {
        animations.enabled = false;
      };
    };
  };
}

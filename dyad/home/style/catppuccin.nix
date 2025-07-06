{
  lib,
  config,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  options.dyad.theming.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.theming.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;

      cursors = {
        inherit (config.catppuccin) enable;
        accent = "dark";
      };

      firefox.profiles.default = {
        enable = false;
        userstyles.force = true;
      };

      gtk = {
        inherit (config.catppuccin) enable;
        size = "standard";
        tweaks = [ "normal" ];
        icon.enable = true;
      };

      fish.enable = false;
      mpv.enable = false;
    };
  };
}

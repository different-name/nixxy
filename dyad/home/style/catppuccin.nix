{
  lib,
  config,
  osConfig,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    self.homeModules.catppuccinGtk
  ];

  options.dyad.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.style.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;

      # keep-sorted start block=yes
      cursors = {
        inherit (config.catppuccin) enable;
        accent = "dark";
      };
      firefox.enable = false;
      fish.enable = false;
      mpv.enable = false;
      yazi.accent = "mauve";
      zellij.enable = false;
      # keep-sorted end
    };
  };
}

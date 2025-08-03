{
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  options.dyad.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.style.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;

      # keep-sorted start block=yes newline_separated=yes
      cursors = {
        inherit (config.catppuccin) enable;
        accent = "dark";
      };

      firefox = {
        enable = false;
        userstyles.force = true;
      };

      fish.enable = false;

      gtk.icon.enable = true;

      mpv.enable = false;

      yazi.accent = "mauve";

      zellij.enable = false;
      # keep-sorted end
    };
  };
}

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

  options.dyad.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.style.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;

      # keep-sorted start block=yes newline_separated=yes
      cursors = {
        inherit (config.catppuccin) enable;
        accent = "dark";
      };

      firefox.profiles.default = {
        enable = false;
        userstyles.force = true;
      };

      fish.enable = false;

      gtk = {
        inherit (config.catppuccin) enable;
        size = "standard";
        tweaks = [ "normal" ];
        icon.enable = true;
      };

      mpv.enable = false;

      yazi.accent = "mauve";

      zellij.enable = false;
      # keep-sorted end
    };
  };
}

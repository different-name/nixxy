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

  options.nix-files.parts.theming.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.nix-files.parts.theming.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;

      cursors = {
        inherit (config.catppuccin) enable flavor;
        accent = "dark";
      };

      firefox.profiles.default = {
        userstyles = {
          enable = true;
          force = true;
        };
      };

      gtk = {
        inherit (config.catppuccin) enable flavor accent;
        size = "standard";
        tweaks = [ "normal" ];
        icon.enable = true;
      };

      fish.enable = false;
      mpv.enable = false;
    };
  };
}

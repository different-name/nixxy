{
  lib,
  config,
  inputs,
  osConfig,
  ...
}: {
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  options.nix-files.catppuccin.enable = lib.mkEnableOption "Catppuccin config";

  config = lib.mkIf config.nix-files.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;

      cursors = {
        inherit (osConfig.catppuccin) flavor;
        enable = true;
        accent = "dark";
      };

      gtk = {
        enable = true;
        flavor = "mocha";
        accent = "red";
        size = "standard";
        tweaks = ["normal"];
        icon.enable = true;
      };

      btop.enable = true;
      fish.enable = false;
      mpv.enable = false;
    };
  };
}

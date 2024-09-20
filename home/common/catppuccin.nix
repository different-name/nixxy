{
  lib,
  config,
  inputs,
  osConfig,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  options.nix-files.catppuccin.enable = lib.mkEnableOption "Catppuccin config";

  config = lib.mkIf config.nix-files.catppuccin.enable {
    catppuccin = {
      inherit (osConfig.catppuccin) enable accent flavor;
      pointerCursor = {
        inherit (osConfig.catppuccin) flavor;
        enable = true;
        accent = "dark";
      };
    };
  };
}

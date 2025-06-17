{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  options.nix-files.parts.theming.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.nix-files.parts.theming.catppuccin.enable {
    catppuccin = {
      enable = true;
      cache.enable = true;

      accent = "red";
      flavor = "mocha";
    };
  };
}

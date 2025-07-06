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

  options.dyad.theming.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.theming.catppuccin.enable {
    catppuccin = {
      enable = true;
      cache.enable = true;

      accent = "red";
      flavor = "mocha";
    };
  };
}

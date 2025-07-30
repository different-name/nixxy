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

  options.dyad.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.style.catppuccin.enable {
    catppuccin = {
      enable = true;
      cache.enable = true;

      accent = "red";
      flavor = "mocha";
    };
  };
}

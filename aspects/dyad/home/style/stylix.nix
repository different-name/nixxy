{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  options.dyad.style.stylix.enable = lib.mkEnableOption "stylix config";

  config = lib.mkIf config.dyad.style.stylix.enable {
    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = pkgs.base16-schemes + /share/themes/catppuccin-mocha.yaml;

      targets = {
        blender.enable = true;
      };
    };
  };
}

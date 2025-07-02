{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.nix-files.parts.system.home-manager.enable = lib.mkEnableOption "home-manager config";

  config = lib.mkIf config.nix-files.parts.system.home-manager.enable {
    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
    };
  };
}

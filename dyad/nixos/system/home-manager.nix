{
  lib,
  config,
  inputs,
  inputs',
  self,
  self',
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.dyad.system.home-manager.enable = lib.mkEnableOption "home-manager config";

  config = lib.mkIf config.dyad.system.home-manager.enable {
    home-manager = {
      extraSpecialArgs = {
        inherit
          # keep-sorted start
          inputs
          inputs'
          self
          self'
          # keep-sorted end
          ;
      };

      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}

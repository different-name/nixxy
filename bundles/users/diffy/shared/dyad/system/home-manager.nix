{
  bundleLib,
  inputs,
  inputs',
  self,
  self',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "system" "home-manager" ] {
  nixos = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    config.home-manager = {
      extraSpecialArgs = {
        inherit
          inputs
          inputs'
          self
          self'
          ;
      };

      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}

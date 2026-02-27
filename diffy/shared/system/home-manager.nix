{
  bundleLib,
  inputs,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "system" "home-manager" ] {
  nixos = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    config.home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };
  };
}

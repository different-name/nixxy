{
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager

    ./different.nix
    ./iodine.nix
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    useGlobalPkgs = true;
  };
}

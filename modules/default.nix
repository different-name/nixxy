{
  flake = {
    nixosModules = import ./nixos;
    homeManagerModules = import ./home;
  };
}

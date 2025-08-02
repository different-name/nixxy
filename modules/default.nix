{
  flake = {
    flakeModules = import ./flake;
    nixosModules = import ./nixos;
    homeModules = import ./home;
  };
}

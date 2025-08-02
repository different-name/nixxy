{ inputs, ... }:
{
  flake = {
    nixosModules.dyad = inputs.import-tree ./nixos;
    homeModules.dyad = inputs.import-tree ./home;
  };
}

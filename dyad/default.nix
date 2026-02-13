{ inputs, ... }:
{
  flake.homeModules.dyad = inputs.import-tree ./home;
}

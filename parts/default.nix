{ inputs, ... }:
{
  imports = [
    ../configurations/hosts
    ../lib
    ../modules
    ../packages

    ./sources.nix
    ./formatter.nix
  ];

  systems = import inputs.systems;
}

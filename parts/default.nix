{ inputs, ... }:
{
  imports = [
    # keep-sorted start
    ../configurations/hosts
    ../lib
    ../modules
    ../packages
    ./formatter.nix
    ./sources.nix
    # keep-sorted end
  ];

  systems = import inputs.systems;
}

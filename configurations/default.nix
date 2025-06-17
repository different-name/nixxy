{
  inputs,
  lib,
  ...
}:
let
  configurations = [
    "sodium"
    "potassium"
    "iodine"
  ];

  mkNixosSystem =
    configuration:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };

      modules = [
        (inputs.self + /configurations + "/" + configuration)
        (inputs.import-tree ../nixos)
      ];
    };
in
{
  flake.nixosConfigurations = lib.genAttrs configurations mkNixosSystem;
}

{ inputs, lib, ... }:
let
  configurations = [
    "sodium"
    "potassium"
    "iodine"
  ];

  mkNixosSystem =
    configuration:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        lib = lib // {
          nix-files = inputs.self.lib;
        };
      };

      modules = [
        { nix-files.host = configuration; }
        (inputs.import-tree ./nixos)

        # this file is the only module file not imported (directly or indirectly) via import-tree
        # this file is reserved for non-configurable imports, such as modules from nixos-hardware
        "${inputs.self}/nixos/hosts/${configuration}/_special-imports.nix"
      ];
    };
in
{
  flake.nixosConfigurations = lib.genAttrs configurations mkNixosSystem;
}

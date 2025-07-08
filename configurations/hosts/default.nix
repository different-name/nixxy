{
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  hosts = {
    # keep-sorted start
    potassium = "x86_64-linux";
    sodium = "x86_64-linux";
    # keep-sorted end
  };

  mkNixosSystem =
    hostName: system:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          # keep-sorted start
          inputs
          self
          # keep-sorted end
          ;
      };

      modules = [
        ./${hostName}
        ../users

        (inputs.import-tree [
          (self + /dyad/nixos)
        ])

        {
          _module.args = withSystem system (
            { self', inputs', ... }:
            {
              inherit self' inputs';
            }
          );
        }
      ];
    };
in
{
  flake.nixosConfigurations = lib.mapAttrs mkNixosSystem hosts;
}

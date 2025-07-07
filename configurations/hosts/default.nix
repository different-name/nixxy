{
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  hosts = {
    potassium = "x86_64-linux";
    sodium = "x86_64-linux";
  };

  mkNixosSystem =
    hostName: system:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          self
          ;
      };

      modules = [
        ./${hostName}
        ../users

        (inputs.import-tree [
          (self + /dyad/nixos)
        ])

        { dyad.host = hostName; }

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

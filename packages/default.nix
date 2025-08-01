{ lib, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      self',
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };

      packages =
        builtins.readDir ./.
        |> lib.filterAttrs (_: value: value == "directory")
        |> lib.mapAttrs (name: _: pkgs.callPackage ./${name} { inherit (self') sources; });
    };
}

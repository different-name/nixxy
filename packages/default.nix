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
          android_sdk.accept_license = true;
        };
      };

      packages =
        builtins.readDir ./.
        |> lib.filterAttrs (_: value: value == "directory")
        |> lib.mapAttrs (name: _: pkgs.callPackage ./${name} { inherit (self') sources; });
    };
}

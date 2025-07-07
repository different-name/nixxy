{ lib, ... }:
{
  perSystem =
    { pkgs, self', ... }:
    {
      packages =
        builtins.readDir ../packages
        |> lib.filterAttrs (_: value: value == "directory")
        |> lib.mapAttrs (name: _: pkgs.callPackage ./${name} { inherit (self') sources; });
    };
}

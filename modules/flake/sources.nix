{ lib, flake-parts-lib, ... }:
flake-parts-lib.mkTransposedPerSystemModule {
  name = "sources";
  option = lib.mkOption {
    type = lib.types.attrs;
    default = { };
    description = "An attribute set of nvfetcher sources";
  };
  file = ./default.nix;
}

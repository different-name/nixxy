{ lib, flake-parts-lib, ... }:
let
  inherit (lib) types;
in
flake-parts-lib.mkTransposedPerSystemModule {
  name = "extensions";
  option = lib.mkOption {
    type = types.attrsOf types.attrsOf types.package;
    default = { };
  };
  file = ./extensions.nix;
}

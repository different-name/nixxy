{ lib, flake-parts-lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    (flake-parts-lib.mkTransposedPerSystemModule {
      name = "sources";
      option = lib.mkOption {
        type = types.attrs;
        default = { };
        description = "An attribute set of nvfetcher sources";
      };
      file = ./sources.nix;
    })
  ];

  perSystem =
    { pkgs, ... }:
    {
      sources = import ../_sources/generated.nix {
        inherit (pkgs)
          fetchgit
          fetchurl
          fetchFromGitHub
          dockerTools
          ;
      };
    };
}

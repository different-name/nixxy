{ lib, flake-parts-lib, ... }:
{
  imports = [
    (flake-parts-lib.mkTransposedPerSystemModule {
      name = "sources";
      option = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "An attribute set of nvfetcher sources";
      };
      file = ./default.nix;
    })
  ];

  perSystem =
    { pkgs, ... }:
    {
      sources = import ./_sources/generated.nix {
        inherit (pkgs)
          fetchgit
          fetchurl
          fetchFromGitHub
          dockerTools
          ;
      };
    };
}

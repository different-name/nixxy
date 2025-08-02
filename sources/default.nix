{
  imports = [
    ../modules/flake/sources.nix
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

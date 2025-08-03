{
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

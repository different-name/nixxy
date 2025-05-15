{
  perSystem = {pkgs, ...}: {
    packages = let
      nvSources = import ./_sources/generated.nix {
        inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;
      };

      mkPackageAttr = path: let
        package = pkgs.callPackage path {inherit nvSources;};
      in {
        name = package.pname or package.name;
        value = package;
      };
    in
      [
        ./nd
        ./tascam
        ./wivrn-solarxr.nix
      ]
      |> map mkPackageAttr
      |> builtins.listToAttrs;
  };
}

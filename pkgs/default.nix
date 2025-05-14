{
  perSystem = {pkgs, ...}: {
    packages = let
      nvSources = import ./_sources/generated.nix {
        inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;
      };

      mkPackageAttr = path: let
        package = pkgs.callPackage path {inherit nvSources;};
      in {
        name = package.pname;
        value = package;
      };
    in
      [
        ./wivrn-solarxr.nix
      ]
      |> map mkPackageAttr
      |> builtins.listToAttrs;
  };
}

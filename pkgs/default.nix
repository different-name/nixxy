{
  perSystem = {pkgs, ...}: let
    sources = import ./_sources/generated.nix {
      inherit (pkgs) fetchgit fetchurl fetchFromGitHub dockerTools;
    };

    mkPackageAttr = path: let
      package = pkgs.callPackage path {inherit sources;};
    in {
      name = package.pname or package.name;
      value = package;
    };
  in {
    packages =
      [
        ./cats-blender-plugin-unofficial
        ./mcuuid
        ./nt
        ./tascam
        ./wivrn-solarxr
      ]
      |> map mkPackageAttr
      |> builtins.listToAttrs;
  };
}

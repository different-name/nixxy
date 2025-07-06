{
  perSystem =
    { pkgs, ... }:
    let
      sources = import ./_sources/generated.nix {
        inherit (pkgs)
          fetchgit
          fetchurl
          fetchFromGitHub
          dockerTools
          ;
      };

      mkPackageAttr =
        path:
        let
          package = pkgs.callPackage path { inherit sources; };
        in
        {
          name = package.pname or package.name;
          value = package;
        };
    in
    {
      packages =
        [
          ./catppuccin-firefox-mocha
          ./catppuccin-obsidian-theme
          ./catppuccin-vrcx-mocha
          ./cats-blender-plugin-unofficial
          ./disblock-origin
          ./mcuuid
          ./slimevr-cli
          ./osc-goes-brrr
        ]
        |> map mkPackageAttr
        |> builtins.listToAttrs;
    };
}

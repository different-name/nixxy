{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "patches" ] {
  nixos = {
    nixpkgs.overlays = [
      (_final: prev: {
        # patch src (not .patches) so slimevr-server gets it too
        slimevr = prev.slimevr.overrideAttrs (old: {
          src = prev.applyPatches {
            inherit (old) src;
            patches = [
              (builtins.path {
                path = ./slimevr/launch-server-seperately.patch;
                name = "slimevr-launch-server-seperately";
              })
              (builtins.path {
                path = ./slimevr/force-standing-pose.patch;
                name = "slimevr-force-standing-pose";
              })
            ];
          };
        });

        # patch src (not .patches) so vrcx's dotnet-backend derivation gets it too
        vrcx = prev.vrcx.overrideAttrs (old: {
          src = prev.applyPatches {
            inherit (old) src;
            patches = [
              (prev.fetchpatch {
                name = "vrcx-linux-open-in-game";
                url = "https://github.com/vrcx-team/VRCX/compare/07c9d52fd577680112e9124d37dd9cc3360cac93...different-name:4f5b2c8b4a49dbc1e3f7304f1f85b32a086a29cd.patch";
                hash = "sha256-1pAn7hiJWahM3SIn9XnYLBkrwaI6+c7VPNnQk0ca6b4=";
              })
            ];
          };
        });
      })
    ];
  };
}

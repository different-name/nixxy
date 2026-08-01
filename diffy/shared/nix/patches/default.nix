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
              (builtins.path {
                path = ./vrcx/linux-open-in-game.patch;
                name = "vrcx-linux-open-in-game";
              })
            ];
          };
        });
      })
    ];
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "patches" ] {
  nixos = {
    nixpkgs.overlays = [
      (_final: prev: {
        slimevr = prev.slimevr.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (builtins.path {
              path = ./slimevr/launch-server-seperately.patch;
              name = "slimevr-launch-server-seperately";
            })
          ];
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

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

        wayvr = prev.wayvr.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (builtins.path {
              path = ./wayvr/destroy-dmabuf-params.patch;
              name = "wayvr-destroy-dmabuf-params";
            })
            (builtins.path {
              path = ./wayvr/gradient-intensity-config.patch;
              name = "wayvr-gradient-intensity-config";
            })
            (builtins.path {
              path = ./wayvr/keycap-style.patch;
              name = "wayvr-keycap-style";
            })
            (builtins.path {
              path = ./wayvr/primary-key-hover.patch;
              name = "wayvr-primary-key-hover";
            })
            (builtins.path {
              path = ./wayvr/space-rotate-hand-anchor.patch;
              name = "wayvr-space-rotate-hand-anchor";
            })
          ];
        });
      })
    ];
  };
}

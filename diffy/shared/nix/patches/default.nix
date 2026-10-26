{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "patches" ] {
  nixos = {
    nixpkgs.overlays = lib.singleton (
      _final: prev: {
        # NixOS/nixpkgs#575861, modules_install runs depmod and its output collides with the kernel's
        linuxPackages_zen = prev.linuxPackages_zen.extend (
          _kfinal: kprev: {
            v4l2loopback = kprev.v4l2loopback.overrideAttrs (old: {
              installFlags = (old.installFlags or [ ]) ++ [ "DEPMOD=true" ];
            });
          }
        );

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
              path = ./wayvr/space-rotate-hand-anchor.patch;
              name = "wayvr-space-rotate-hand-anchor";
            })
          ];
        });
      }
    );
  };
}

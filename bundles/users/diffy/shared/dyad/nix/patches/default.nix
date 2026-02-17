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
      })
    ];

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

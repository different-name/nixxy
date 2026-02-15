{ bundleLib, self, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "nixpkgs" ] {
  nixos = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        segger-jlink.acceptLicense = true;
      };

      overlays = [
        (_final: prev: {
          slimevr = prev.slimevr.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              (builtins.path {
                path = self + /patches/slimevr/launch-server-seperately.patch;
                name = "slimevr-launch-server-seperately";
              })
            ];
          });
        })
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

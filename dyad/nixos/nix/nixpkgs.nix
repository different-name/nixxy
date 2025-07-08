{
  lib,
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.nur.modules.nixos.default
  ];

  options.dyad.nix.nixpkgs.enable = lib.mkEnableOption "nixpkgs config";

  config = lib.mkIf config.dyad.nix.nixpkgs.enable {
    nixpkgs = {
      config.allowUnfree = true;

      overlays = [
        # keep-sorted start block=yes newline_separated=yes
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

        (_final: prev: {
          wlx-overlay-s = prev.wlx-overlay-s.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              # keep-sorted start block=yes newline_separated=yes
              (builtins.path {
                path = self + /patches/wlx-overlay-s/catppuccin-colors.patch;
                name = "wlx-overlay-s-catppuccin-colors";
              })

              (builtins.path {
                path = self + /patches/wlx-overlay-s/yaw-reset.patch;
                name = "wlx-overlay-s-yaw-reset";
              })
              # keep-sorted end
            ];
          });
        })
        # keep-sorted end
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

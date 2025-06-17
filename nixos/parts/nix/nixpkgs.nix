{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nur.modules.nixos.default
  ];

  options.nix-files.parts.nix.nixpkgs.enable = lib.mkEnableOption "nixpkgs config";

  config = lib.mkIf config.nix-files.parts.nix.nixpkgs.enable {
    nixpkgs = {
      config.allowUnfree = true;

      overlays = [
        (final: prev: {
          slimevr = prev.slimevr.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              # https://nix.dev/guides/best-practices.html#reproducible-source-paths
              (builtins.path {
                path = inputs.self + /patches/slimevr/launch-slimevr-server-seperately.patch;
                name = "slimevr-launch-slimevr-server-seperately";
              })
            ];
          });
        })

        (final: prev: {
          wlx-overlay-s = prev.wlx-overlay-s.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [
              # https://nix.dev/guides/best-practices.html#reproducible-source-paths
              (builtins.path {
                path = inputs.self + /patches/wlx-overlay-s/catppuccin-colors.patch;
                name = "wlx-overlay-s-catppuccin-colors";
              })
            ];
          });
        })
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

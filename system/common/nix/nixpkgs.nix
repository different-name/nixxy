{
  lib,
  config,
  inputs,
  self,
  ...
}: {
  imports = [
    inputs.nur.modules.nixos.default
  ];

  options.nix-files.nix.nixpkgs.enable = lib.mkEnableOption "Nixpkgs config";

  config = lib.mkIf config.nix-files.nix.nixpkgs.enable {
    nixpkgs = {
      config.allowUnfree = true;

      overlays = [
        (final: prev: {
          slimevr = prev.slimevr.overrideAttrs (old: {
            patches =
              (old.patches or [])
              ++ [
                # https://nix.dev/guides/best-practices.html#reproducible-source-paths
                (builtins.path {
                  path = "${self}/patches/slimevr/launch-slimevr-server-seperately.patch";
                  name = "slimevr-launch-slimevr-server-seperately";
                })
              ];
          });
        })
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

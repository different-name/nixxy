{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nur.modules.homeManager.default
  ];

  options.nix-files.core.enable = lib.mkEnableOption "Core home config";

  config = lib.mkIf config.nix-files.core.enable {
    nixpkgs.config.allowUnfree = true;

    nixpkgs.overlays = [
      (final: prev: {
        catppuccin-cursors = prev.catppuccin-cursors.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "Covkie";
            repo = "cursors";
            rev = "d52431d99e9421c849ba16d07eaaf6b5113b114d";
            hash = "sha256-b7P35YyevlgeNKk7VzyyGl566BZ4LwpHMVmQ8OO0LlY=";
          };

          buildPhase = ''
            runHook preBuild

            patchShebangs .
            just all
            just zip

            runHook postBuild
          '';

          nativeBuildInputs =
            old.nativeBuildInputs
            ++ [
              prev.zip
            ];
        });
      })
    ];

    # let home-manager manage itself when in standalone mode
    programs.home-manager.enable = true;

    # reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}

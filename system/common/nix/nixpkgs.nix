{
  lib,
  config,
  inputs,
  pkgs,
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
          # Nvidia GPU support
          # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
          btop = prev.btop.override {cudaSupport = true;};
        })

        (final: prev: {
          prismlauncher = prev.prismlauncher.override {
            jdks = with pkgs; [
              temurin-bin
            ];
          };
        })

        (final: prev: {
          # let me disable the silly popups
          vencord = prev.vencord.overrideAttrs {
            patches = [./patches/disableSupportHelper.patch];
          };
        })

        (final: prev: {
          discord = prev.discord.override {withVencord = true;};
        })

        (final: prev: {
          # slimevr tracker support for wivrn
          # https://lvra.gitlab.io/docs/fossvr/wivrn/#nixos-setup
          wivrn = prev.wivrn.overrideAttrs (old: rec {
            version = "3cea1afee2c29d00056b3a10687431990ef860c8";
            src = pkgs.fetchFromGitHub {
              owner = "notpeelz";
              repo = "WiVRn";
              rev = version;
              hash = "sha256-zaJoW5rnzcKn/vQrepJSFEJU1b3eyBwu1ukJLCjtJtE=";
            };
            cmakeFlags =
              old.cmakeFlags
              ++ [
                (lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
              ];
          });
        })

        (final: prev: {
          # workaround for slimevr gui for wayland + nvidia
          # Requires WEBKIT_DISABLE_DMABUF_RENDERER=1 in the environment
          # https://github.com/tauri-apps/tauri/issues/9394
          slimevr = prev.slimevr.overrideAttrs (old: {
            postPatch = ''
              ${old.postPatch or ""}
              substituteInPlace gui/src-tauri/dev.slimevr.SlimeVR.desktop \
                --replace 'Exec={{exec}}' 'Exec=env WEBKIT_DISABLE_DMABUF_RENDERER=1 {{exec}}'
            '';
          });
        })
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

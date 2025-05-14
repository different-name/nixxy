{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.services.xr.enable = lib.mkEnableOption "XR config";

  config = lib.mkIf config.nix-files.services.xr.enable {
    services.wivrn = {
      enable = true;

      # slimevr tracker support for wivrn
      # https://lvra.gitlab.io/docs/fossvr/wivrn/#nixos-setup
      package = pkgs.wivrn.overrideAttrs (old: rec {
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

      openFirewall = true;
      defaultRuntime = true;
      autoStart = true;

      config = {
        enable = true;
        json = {
          # 100 Mb/s
          bitrate = 100000000;
          application = pkgs.wlx-overlay-s;
        };
      };
    };

    # slimevr server
    networking.firewall.allowedUDPPorts = [6969];

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/root/.config/dev.slimevr.SlimeVR"
        "/root/.local/share/dev.slimevr.SlimeVR"
      ];
    };
  };
}

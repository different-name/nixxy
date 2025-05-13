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

{ lib, config, ... }: {
  config = lib.mkIf config.dyad.games.xr.enable {
    nixos = { pkgs, ... }: {
      services.wivrn = {
        enable = true;
        openFirewall = true;
        steam.importOXRRuntimes = true;

        config = {
          enable = true;
          json = {
            bitrate =
              let
                Mbps = 80;
              in
              Mbps * 1000000;

            encoders = lib.singleton {
              encoder = if config.dyad.hardware.nvidia.enable then "nvenc" else "vaapi";
              codec = "h265";
              width = 1.0;
              height = 1.0;
              offset_x = 0.0;
              offset_y = 0.0;
            };

            application = lib.singleton (
              pkgs.writeShellScriptBin "wivrn-applications" ''
                ${lib.getExe' pkgs.systemd "systemctl"} --user start wayvr solarxr-input
              ''
            );
          };
        };
      };

      systemd.user.services.wivrn = {
        after = [ "slimevr-server.service" ];
        requires = [ "slimevr-server.service" ];
        partOf = [ "vr-session.target" ];
        wantedBy = [ "vr-session.target" ];

        # hold activating until the openxr compositor ipc socket exists
        serviceConfig.ExecStartPost = pkgs.writeShellScript "wait-wivrn" ''
          for _ in $(seq 1 100); do
            [ -S "$XDG_RUNTIME_DIR/wivrn/comp_ipc" ] && exit 0
            sleep 0.1
          done
          exit 1
        '';
      };
    };

    home-manager.keep.safe = {
      cacheDirs = [ "wivrn" ];
      configDirs = [ "wivrn" ];
    };
  };
}

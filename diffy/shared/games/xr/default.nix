{
  bundleLib,
  lib,
  inputs,
  inputs',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "games" "xr" ] {
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
            encoder = "nvenc";
            codec = "av1";
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

    systemd.user.targets.vr-session.description = "VR session";

    systemd.user.services = {
      slimevr-server = {
        description = "SlimeVR Server";
        partOf = [ "vr-session.target" ];
        wantedBy = [ "vr-session.target" ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.slimevr-server} run";
          # hold activating until the solarxr websocket is listening
          ExecStartPost = pkgs.writeShellScript "wait-slimevr" ''
            for _ in $(seq 1 100); do
              (exec 3<>/dev/tcp/127.0.0.1/21110) 2>/dev/null && exit 0
              sleep 0.1
            done
            exit 1
          '';
          Restart = "on-failure";
        };
      };

      wivrn = {
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

      wayvr = {
        description = "wayvr";
        after = [ "wivrn.service" ];
        requires = [ "wivrn.service" ];
        partOf = [ "wivrn.service" ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wayvr} --openxr --replace";
          Restart = "on-failure";
        };
      };

      solarxr-input = {
        description = "SolarXR OpenXR bindings";
        after = [
          "wivrn.service"
          "slimevr-server.service"
        ];
        requires = [ "wivrn.service" ];
        wants = [ "slimevr-server.service" ];
        partOf = [ "wivrn.service" ];

        serviceConfig = {
          ExecStart = lib.getExe' inputs'.solarxr-cli.packages.solarxr-cli "solarxr-input";
          Restart = "on-failure";
        };
      };
    };

    # slimevr server
    networking.firewall.allowedUDPPorts = [ 6969 ];

    # slimevr tracker udev rules
    services.udev.packages = [ pkgs.slimevr ];

    environment.systemPackages = [
      inputs'.solarxr-cli.packages.default
    ];

    environment.perpetual.default.dirs = [
      "/root/.config/dev.slimevr.SlimeVR"
      "/root/.local/share/dev.slimevr.SlimeVR"
    ];
  };

  home-manager = { pkgs, ... }: {
    xdg = {
      # https://github.com/wlx-team/wayvr/wiki/Customization
      configFile."wayvr" = {
        source = ./wayvr;
        recursive = true;
        force = true;
      };

      configFile."solarxr-input/config.json".text = lib.toJSON {
        action_profiles = {
          "/interaction_profiles/oculus/touch_controller" = {
            reset_yaw = {
              left = "/user/hand/left/input/y/click";
              double_click = true;
            };
            tracking_pause_toggle = {
              right = "/user/hand/right/input/b/click";
              double_click = true;
            };
          };
          "/interaction_profiles/valve/index_controller" = { };
          "/interaction_profiles/htc/vive_controller" = { };
          "/interaction_profiles/microsoft/motion_controller" = { };
        };
      };

      # https://lvra.gitlab.io/docs/fossvr/xrizer/#rebinding-controls
      dataFile."Steam/steamapps/common/VRChat/xrizer/oculustouch.json" = {
        source = ./binds/vrchat/oculustouch.json;
      };
    };

    home.perpetual.default = {
      packages = {
        # keep-sorted start block=yes newline_separated=yes
        slimevr = {
          # https://github.com/tauri-apps/tauri/issues/9394
          # TODO remove with v19
          package = inputs.wrappers.lib.wrapPackage {
            inherit pkgs;
            package = pkgs.slimevr;
            env.WEBKIT_DISABLE_DMABUF_RENDERER = 1;
          };
          dirs = [
            # keep-sorted start
            "$cacheHome/.slimevr-wrapped_"
            "$configHome/dev.slimevr.SlimeVR"
            "$dataHome/.slimevr-wrapped_"
            "$dataHome/dev.slimevr.SlimeVR"
            # keep-sorted end
          ];
        };

        wayvr.dirs = [
          "$configHome/wayvr"
        ];
        # keep-sorted end
      };

      dirs = [
        # keep-sorted start
        "$cacheHome/wivrn"
        "$configHome/openvr"
        "$configHome/wivrn"
        "$stateHome/OpenComposite"
        # keep-sorted end
      ];
    };
  };
}

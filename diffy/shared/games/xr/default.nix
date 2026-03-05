{
  bundleLib,
  lib,
  inputs,
  inputs',
  self',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "games" "xr" ] {
  nixos =
    { pkgs, ... }:
    {
      services.wivrn = {
        enable = true;

        openFirewall = true;
        defaultRuntime = true;

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
              codec = "h264";
              width = 1.0;
              height = 1.0;
              offset_x = 0.0;
              offset_y = 0.0;
            };

            openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
          };
        };
      };

      systemd.user.services = {
        slimevr-server = {
          description = "SlimeVR Server";

          serviceConfig = {
            ExecStart = "${lib.getExe pkgs.slimevr-server} run";
            Restart = "on-failure";
          };
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
      };

      # slimevr server
      networking.firewall.allowedUDPPorts = [ 6969 ];

      environment.systemPackages = [
        pkgs.slimevr # installed at system level for udev rules
        inputs'.solarxr-cli.packages.default
      ];

      environment.perpetual.default.dirs = [
        "/root/.config/dev.slimevr.SlimeVR"
        "/root/.local/share/dev.slimevr.SlimeVR"
      ];
    };

  home-manager =
    { osConfig, pkgs, ... }:
    {
      xdg = {
        # https://lvra.gitlab.io/docs/distros/nixos/#runtimes
        configFile."openxr/1/active_runtime.json" = {
          inherit (osConfig.environment.etc."xdg/openxr/1/active_runtime.json") source;
          force = true;
        };

        # https://github.com/wlx-team/wayvr/wiki/Customization
        configFile."wayvr" = {
          source = ./wayvr;
          recursive = true;
          force = true;
        };

        # https://lvra.gitlab.io/docs/fossvr/opencomposite/#rebinding-controls
        dataFile."Steam/steamapps/common/VRChat/OpenComposite/oculus_touch.json" = {
          source = ./opencomposite/vrchat/oculus_touch.json;
        };
      };

      # TODO temporary workaround until https://www.github.com/hyprwm/xdg-desktop-portal-hyprland/issues/329 is implemented properly
      wayland.windowManager.hyprland.xdgDesktopPortalHyprland.settings = {
        screencopy = {
          custom_picker_binary = lib.getExe (
            pkgs.writeShellApplication {
              name = "hyprland-share-picker-xr";
              runtimeInputs = [ osConfig.programs.hyprland.portalPackage ];
              text = lib.readFile ./hyprland-share-picker-xr.sh;
            }
          );
        };
      };

      home.perpetual.default = {
        packages = {
          # keep-sorted start block=yes newline_separated=yes
          oscgoesbrrr = {
            package = self'.packages.oscgoesbrrr;
            dirs = [
              "$configHome/OscGoesBrrr"
            ];
          };

          slimevr = {
            # https://github.com/tauri-apps/tauri/issues/9394
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

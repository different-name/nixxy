{
  bundleLib,
  lib,
  inputs,
  inputs',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "games" "xr" ] {
  nixos =
    { pkgs, ... }:
    {
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
              codec = "h264";
              width = 1.0;
              height = 1.0;
              offset_x = 0.0;
              offset_y = 0.0;
            };
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
    { pkgs, ... }:
    {
      xdg = {
        # https://github.com/wlx-team/wayvr/wiki/Customization
        configFile."wayvr" = {
          source = ./wayvr;
          recursive = true;
          force = true;
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

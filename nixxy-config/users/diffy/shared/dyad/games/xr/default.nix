{
  lib,
  config,
  inputs',
  self',
  ...
}:
{
  options.dyad.games.xr.enable = lib.mkEnableOption "xr config";

  config = lib.mkIf config.dyad.games.xr.enable {
    nixos =
      { config, pkgs, ... }:
      {
        services.wivrn = {
          enable = true;
          package = inputs'.wivrn.packages.default;

          openFirewall = true;
          defaultRuntime = true;
          extraServerFlags = [ "--no-manage-active-runtime" ];

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

        # slimevr server
        networking.firewall.allowedUDPPorts = [ 6969 ];

        systemd.user.services = {
          slimevr-server = {
            description = "SlimeVR Server";
            partOf = [ "vr-session.service" ];

            serviceConfig = {
              ExecStart = "${lib.getExe pkgs.slimevr-server} run";
              Restart = "on-failure";
            };
          };

          wait-for-slimevr-server = {
            description = "Wait for SlimeVR Server to be ready and remain active while it runs";
            after = [ "slimevr-server.service" ];
            requires = [ "slimevr-server.service" ];

            serviceConfig = {
              Type = "notify";
              ExecStart = lib.getExe (
                pkgs.writeShellScriptBin "wait-for-slimevr-server" ''
                  set -eu pipefail

                  timeout 15s journalctl --user -fu slimevr-server.service |
                    grep -m1 "\[SolarXR Bridge\] Socket /run/user/1000/SlimeVRRpc created"
                  set -o pipefail

                  ${pkgs.systemd}/bin/systemd-notify --ready

                  exec sleep infinity
                ''
              );
              NotifyAccess = "all";
            };
          };

          # extends the service provided by services.wivrn
          # https://github.com/NixOS/nixpkgs/blob/adaa24fbf46737f3f1b5497bf64bae750f82942e/nixos/modules/services/video/wivrn.nix#L183-L213
          wivrn = {
            after = [ "wait-for-slimevr-server.service" ];
            requires = [ "wait-for-slimevr-server.service" ];
            partOf = [ "vr-session.service" ];
          };

          wait-for-wivrn = {
            description = "Wait for Wivrn to be ready and remain active while it runs";
            after = [ "wivrn.service" ];
            requires = [ "wivrn.service" ];
            partOf = [ "wivrn.service" ];

            serviceConfig = {
              Type = "notify";
              ExecStart = lib.getExe (
                pkgs.writeShellScriptBin "wait-for-wivrn" ''
                  set -eu pipefail

                  timeout 15s journalctl --user -fu wivrn.service |
                    grep -m1 "Service published: ${config.networking.hostName}"
                  set -o pipefail

                  sleep 0.5
                  ${pkgs.systemd}/bin/systemd-notify --ready

                  exec sleep infinity
                ''
              );
              NotifyAccess = "all";
            };
          };

          wayvr = {
            description = "wayvr";
            after = [ "wait-for-wivrn.service" ];
            requires = [ "wait-for-wivrn.service" ];
            partOf = [
              "vr-session.service"
              "wivrn.service"
            ];

            serviceConfig = {
              ExecStart = "${lib.getExe pkgs.wayvr} --openxr --replace";
              Restart = "on-failure";
              ExecStopSignal = "SIGKILL";
              KillSignal = "SIGKILL";
              SendSIGKILL = "yes";
              TimeoutStopSec = "1s";
            };
          };

          vr-session =
            let
              deps = [
                # keep-sorted start
                "slimevr-server.service"
                "wayvr.service"
                "wivrn.service"
                # keep-sorted end
              ];
            in
            {
              description = "VR session meta service";
              after = deps;
              wants = deps;

              serviceConfig = {
                Type = "oneshot";
                ExecStart = pkgs.coreutils + /bin/true;
                RemainAfterExit = "yes";
              };
            };
        };

        environment.systemPackages = [
          inputs'.solarxr-cli.packages.default
        ];

        services.udev.packages = [
          self'.packages.slimevr-udev-rules
        ];

        environment.perpetual.default.dirs = [
          "/root/.config/dev.slimevr.SlimeVR"
          "/root/.local/share/dev.slimevr.SlimeVR"
        ];
      };

    hm =
      { osConfig, pkgs, ... }:
      {
        xdg.desktopEntries =
          let
            vr-session-manager = pkgs.writeShellApplication {
              name = "vr-session-manager";
              runtimeInputs = with pkgs; [
                libnotify
                systemd
                config.wayland.windowManager.hyprland.package
              ];
              text = lib.readFile (
                pkgs.replaceVars ./vr-session-manager.sh {
                  enter_vr_hook = "hyprctl keyword input:follow_mouse 2";
                  exit_vr_hook = "hyprctl keyword input:follow_mouse 1";
                }
              );
            };

            baseEntry = {
              type = "Application";
              terminal = false;
              categories = [ "Utility" ];
              startupNotify = false;
            };
          in
          {
            start-vr-session = {
              name = "Start VR Session";
              exec = "${lib.getExe vr-session-manager} start";
            }
            // baseEntry;

            stop-vr-session = {
              name = "Stop VR Session";
              exec = "${lib.getExe vr-session-manager} stop";
            }
            // baseEntry;
          };

        # https://lvra.gitlab.io/docs/distros/nixos/#recommendations
        xdg.configFile."openvr/openvrpaths.vrpath" = {
          text = ''
            {
              "config" :
              [
                "~/.local/share/Steam/config"
              ],
              "external_drivers" : null,
              "jsonid" : "vrpathreg",
              "log" :
              [
                "~/.local/share/Steam/logs"
              ],
              "runtime" :
              [
                "${pkgs.opencomposite}/lib/opencomposite"
              ],
              "version" : 1
            }
          '';
          force = true;
        };

        xdg.configFile."openxr/1/active_runtime.json" = {
          inherit (osConfig.environment.etc."xdg/openxr/1/active_runtime.json") source;
          force = true;
        };

        # https://github.com/wlx-team/wayvr/wiki/Customization
        xdg.configFile."wayvr" = {
          source = ./wayvr;
          recursive = true;
          force = true;
        };

        # https://lvra.gitlab.io/docs/fossvr/opencomposite/#rebinding-controls
        xdg.dataFile =
          let
            steamDir = "Steam/steamapps/common";
          in
          {
            "${steamDir}/VRChat/OpenComposite/oculus_touch.json".source =
              ./opencomposite/vrchat/oculus_touch.json;
          };

        xdg.configFile."VRCX/custom.css".source =
          self'.packages.catppuccin-vrcx-mocha + /share/vrcx-catppuccin.css;

        # TODO temporary workaround until https://www.github.com/hyprwm/xdg-desktop-portal-hyprland/issues/329 is implemented properly
        wayland.windowManager.hyprland.xdgDesktopPortalHyprland.settings = {
          screencopy = {
            custom_picker_binary = lib.getExe (
              pkgs.writeShellApplication {
                name = "hyprland-share-picker-xr";
                runtimeInputs = [ osConfig.programs.hyprland.portalPackage ];
                text = builtins.readFile ./hyprland-share-picker-xr.sh;
              }
            );
          };
        };

        home.perpetual.default = {
          packages = {
            # keep-sorted start block=yes newline_separated=yes
            osc-goes-brrr = {
              package = self'.packages.osc-goes-brrr;
              dirs = [
                "$configHome/OscGoesBrrr"
              ];
            };

            slimevr = {
              # https://github.com/tauri-apps/tauri/issues/9394
              package = pkgs.symlinkJoin {
                name = "slimevr";
                paths = [ pkgs.slimevr ];
                nativeBuildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                  wrapProgram $out/bin/slimevr \
                    --set WEBKIT_DISABLE_DMABUF_RENDERER 1
                '';
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

            vrcx.dirs = [
              "$configHome/VRCX"
            ];

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
  };
}

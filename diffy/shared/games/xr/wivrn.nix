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

      services.pipewire.wireplumber = {
        extraScripts."wivrn-mic-volume.lua" = ''
          SimpleEventHook {
            name = "wivrn-mic-volume",
            interests = {
              EventInterest {
                Constraint { "event.type", "=", "node-added" },
                Constraint { "node.name", "=", "wivrn.source" },
              },
            },
            execute = function (event)
              event:get_subject ():set_param ("Props", Pod.Object {
                "Spa:Pod:Object:Param:Props", "Props",
                -- wpctl and pavucontrol show cubic volume
                channelVolumes = Pod.Array { "Spa:Float", 1.5 ^ 3 },
              })
            end
          }:register ()
        '';

        extraConfig."50-wivrn-mic-volume" = {
          "wireplumber.components" = lib.singleton {
            name = "wivrn-mic-volume.lua";
            type = "script/lua";
            provides = "custom.wivrn-mic-volume";
          };
          "wireplumber.profiles".main."custom.wivrn-mic-volume" = "required";
          "stream.rules" = lib.singleton {
            matches = lib.singleton { "node.name" = "wivrn.source"; };
            actions.update-props."state.restore-props" = false;
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

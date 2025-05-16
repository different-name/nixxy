{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.games.xr.enable = lib.mkEnableOption "XR config";

  config = lib.mkIf config.nix-files.graphical.games.xr.enable {
    xdg.desktopEntries = let
      vr-session-manager = pkgs.writeShellApplication {
        name = "vr-session-manager";
        runtimeInputs = with pkgs; [
          libnotify
          systemd
        ];
        text = builtins.readFile ./vr-session-manager.sh;
      };

      baseEntry = {
        type = "Application";
        terminal = false;
        categories = ["Utility"];
        startupNotify = false;
      };
    in {
      start-vr-session =
        {
          name = "Start VR Session";
          exec = "${lib.getExe vr-session-manager} start";
        }
        // baseEntry;

      stop-vr-session =
        {
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

    # https://github.com/galister/wlx-overlay-s/wiki
    xdg.configFile."wlxoverlay" = {
      source = ./wlx-overlay-s;
      recursive = true;
      force = true;
    };

    # https://lvra.gitlab.io/docs/fossvr/opencomposite/#rebinding-controls
    xdg.dataFile = let
      steamDir = "Steam/steamapps/common";
    in {
      "${steamDir}/VRChat/OpenComposite/oculus_touch.json".source =
        ./opencomposite/vrchat/oculus_touch.json;
    };

    xdg.configFile."VRCX/custom.css".source = ./vrcx-catppuccin.css;

    home.packages = with pkgs; [
      wlx-overlay-s
      vrcx

      # https://github.com/tauri-apps/tauri/issues/9394
      (symlinkJoin {
        name = "slimevr";
        paths = [slimevr];
        buildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/slimevr \
            --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        '';
      })
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/wivrn"
        ".cache/wivrn"

        ".config/openvr"

        ".local/state/OpenComposite"

        ".config/wlxoverlay"

        ".config/VRCX"

        ".config/dev.slimevr.SlimeVR"
        ".local/share/dev.slimevr.SlimeVR"
        ".local/share/.slimevr-wrapped_"
        ".cache/.slimevr-wrapped_"
      ];
    };
  };
}

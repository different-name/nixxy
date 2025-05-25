{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.nix-files.graphical.games.xr;
in {
  options.nix-files.graphical.games.xr = {
    enable = lib.mkEnableOption "XR config";

    enterVrHook = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Command to run before entering VR";
    };

    exitVrHook = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Command to run after exiting VR";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.desktopEntries = let
      vr-session-manager = pkgs.writeShellApplication {
        name = "vr-session-manager";
        runtimeInputs = with pkgs; [
          libnotify
          systemd
          config.wayland.windowManager.hyprland.package
        ];
        text =
          builtins.readFile ./vr-session-manager.sh
          |> lib.replaceStrings [
            "# __ENTER_VR_HOOK__"
            "# __EXIT_VR_HOOK__"
          ] [
            cfg.enterVrHook
            cfg.exitVrHook
          ];
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

    # TODO temporary workaround until https://www.github.com/hyprwm/xdg-desktop-portal-hyprland/issues/329 is implemented properly
    wayland.windowManager.hyprland.xdg-desktop-portal-hyprland.settings = {
      screencopy = {
        custom_picker_binary = lib.getExe (pkgs.writeShellApplication {
          name = "hyprland-share-picker-xr";
          runtimeInputs = [osConfig.programs.hyprland.portalPackage];
          text = builtins.readFile ./hyprland-share-picker-xr.sh;
        });
      };
    };

    home.packages = with pkgs; [
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
      vrcx
      wlx-overlay-s
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # opencomposite
        ".local/state/OpenComposite"
        ".config/openvr"

        # slimevr
        ".config/dev.slimevr.SlimeVR"
        ".local/share/dev.slimevr.SlimeVR"
        ".local/share/.slimevr-wrapped_"
        ".cache/.slimevr-wrapped_"

        # vrcx
        ".config/VRCX"

        # wivrn
        ".config/wivrn"
        ".cache/wivrn"

        # wlx-overlay-s
        ".config/wlxoverlay"
      ];
    };
  };
}

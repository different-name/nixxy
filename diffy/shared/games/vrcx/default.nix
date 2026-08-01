{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "vrcx" ] {
  home-manager =
    { pkgs, lib, ... }:
    let
      appid = "438100";
      bus = "com.steampowered.App${appid}";

      # vrchat:// handler: forward into the running game
      # requires env vars (games/steam)
      vrchat-launch = pkgs.writeShellApplication {
        name = "vrchat-launch";
        runtimeInputs = with pkgs; [
          coreutils
          gnugrep
          libnotify
          steam-run
        ];
        text = ''
          url="''${1:-}"
          [ -n "$url" ] || {
            echo "usage: vrchat-launch <vrchat://...>" >&2
            exit 2
          }

          steam="''${XDG_DATA_HOME:-$HOME/.local/share}/Steam"
          client="$steam/steamapps/common/SteamLinuxRuntime_4/pressure-vessel/bin/steam-runtime-launch-client"
          launch_exe="$steam/steamapps/common/VRChat/launch.exe"

          # attach=1 = attach-only (vrcx open-in-game), never cold-start these
          attach_only=0
          case "$url" in *attach=1*) attach_only=1 ;; esac

          # launch-client is a steam-runtime binary, so wrap in steam-run
          if [ -x "$client" ] && steam-run "$client" --list 2>/dev/null | grep -qxF -- "--bus-name=${bus}"; then
            # attach=1 makes launch.exe forward instead of cold-starting a 2nd copy
            case "$url" in
              *attach=1*) ;;
              *) url="$url&attach=1" ;;
            esac
            # shellcheck disable=SC2016
            exec steam-run "$client" --inside-app="${appid}" -- \
              /bin/sh -c 'exec wine "$1" "$2"' _ "$launch_exe" "$url"
          fi

          if [ "$attach_only" = 1 ]; then
            notify-send -a VRChat "VRChat" "VRChat isn't running - can't attach." 2>/dev/null || true
            exit 0
          fi

          notify-send -a VRChat "VRChat" "Starting VRChat to open link..." 2>/dev/null || true
          exec steam -applaunch ${appid} "$url"
        '';
      };
    in
    {
      home.packages = [
        pkgs.vrcx
        vrchat-launch
      ];

      xdg = {
        configFile."VRCX/custom.css".source = ./custom.css;

        desktopEntries.vrchat-launch = {
          name = "VRChat Launch Link Handler";
          exec = "${lib.getExe vrchat-launch} %u";
          terminal = false;
          type = "Application";
          noDisplay = true;
          mimeType = [ "x-scheme-handler/vrchat" ];
        };

        mimeApps.defaultApplications."x-scheme-handler/vrchat" = "vrchat-launch.desktop";
      };

      home.perpetual.default.dirs = [
        "$configHome/VRCX"
      ];
    };
}

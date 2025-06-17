{
  lib,
  config,
  osConfig,
  ...
}: {
  config = lib.mkIf config.nix-files.parts.desktop.hyprland.enable {
    wayland.windowManager.hyprland.settings = let
      uwsmCmd = lib.optionalString osConfig.programs.uwsm.enable "uwsm app -- ";
      uwsmApp = cmd: uwsmCmd + cmd;
      uwsmSingleApp = cmd: "pgrep ${cmd} || ${uwsmCmd + cmd}";
    in {
      # l -> locked, will also work when an input inhibitor (e.g. a lockscreen) is active.
      # r -> release, will trigger on release of a key.
      # e -> repeat, will repeat when held.
      # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
      # m -> mouse.
      # t -> transparent, cannot be shadowed by other binds.
      # i -> ignore mods, will ignore modifiers.
      # s -> separate, will arbitrarily combine keys between each mod/key, see [Keysym combos](#keysym-combos) above.
      # d -> has description, will allow you to write a description for your bind.

      "$mod" = "SUPER";

      bindm = [
        # use wev to find mouse button codes
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod CTRL, mouse:272, resizewindow"
      ];

      bind =
        [
          # compositor commands
          "$mod, Q, killactive"
          "$mod, F, fullscreenstate, 2 -1" # fullscreen the window, don't inform the client it was fullscreened
          "$mod SHIFT, F, fullscreenstate, -1 2" # keep current fullscreen state, tell client it is fullscreened
          "$mod, R, togglesplit"
          "$mod, G, togglefloating"
          "$mod, A, togglegroup"
          "$mod SHIFT, A, lockactivegroup, toggle"
          "ALT, TAB, changegroupactive, f"
          "ALT SHIFT, TAB, changegroupactive, b"
          "$mod, T, pin"
          "CTRL ALT, DELETE, exec, ${uwsmApp "hyprctl kill"}"
          "CTRL ALT SHIFT, DELETE, exec, loginctl terminate-user \"\""

          # utility
          ## terminal
          "$mod, RETURN, exec, ${uwsmApp "kitty"}"
          ## lock screen
          "$mod, L, exec, ${uwsmSingleApp "hyprlock"}"
          ## launcher
          "$mod, S, exec, anyrun" # not using uwsm as it introduces latency
          ## browser
          "$mod, W, exec, ${uwsmApp "firefox"}"
          ## file explorer
          "$mod, E, exec, ${uwsmApp "thunar"}"

          # move focus
          "$mod, LEFT, movefocus, l"
          "$mod, RIGHT, movefocus, r"
          "$mod, UP, movefocus, u"
          "$mod, DOWN, movefocus, d"

          # swap windows
          "$mod SHIFT, LEFT, swapwindow, l"
          "$mod SHIFT, RIGHT, swapwindow, r"
          "$mod SHIFT, UP, swapwindow, u"
          "$mod SHIFT, DOWN, swapwindow, d"

          # screenshot
          ## area
          ", PRINT, exec, ${uwsmSingleApp "grimblast"} --notify copy area"
          "$mod SHIFT, S, exec, ${uwsmSingleApp "grimblast"} --notify copy area"
          ## current screen
          "CTRL, PRINT, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copy output"
          "$mod SHIFT CTRL, S, exec, ${uwsmSingleApp "grimblast"} --notify --cursor copy output"

          # cycle workspaces
          "$mod, bracketleft, workspace, m-1"
          "$mod, bracketright, workspace, m+1"
          ",mouse:275, workspace, m-1" # two buttons on the side of my mouse
          ",mouse:276, workspace, m+1"

          # cycle monitors
          "$mod SHIFT, bracketleft, focusmonitor, l"
          "$mod SHIFT, bracketright, focusmonitor, r"

          # send focused workspace to left/right monitors
          "$mod SHIFT ALT, bracketleft, movecurrentworkspacetomonitor, l"
          "$mod SHIFT ALT, bracketright, movecurrentworkspacetomonitor, r"

          # color picker
          "$mod SHIFT, C, exec, ${uwsmSingleApp "hyprpicker"} --autocopy"

          # display time as noficiation
          ''$mod, D, exec, notify-send -t 5000 "$(date "+%a %-d %b %Y | %-I:%M%p")"''

          # ddcutil external monitor brightness
          "$mod, PAGE_UP, exec, ddcutil setvcp 10 + 10"
          "$mod, PAGE_DOWN, exec, ddcutil setvcp 10 - 10"
          (
            let
              getBrightness = "ddcutil getvcp 10 | awk -F'=' '/current value/ { gsub(\",\", \"\", $2); print $2+0 }'";
            in "$mod, PRINT, exec, notify-send -t 5000 \"Current Brightness: $(${getBrightness})%\""
          )
        ]
        # workspace keys
        ++ (map (ws: "$mod, ${ws}, workspace, ${ws}") [
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
        ])
        ++ (map (ws: "$mod SHIFT, ${ws}, movetoworkspace, ${ws}") [
          "1"
          "2"
          "3"
          "4"
          "5"
          "6"
          "7"
          "8"
          "9"
        ]);

      binde = [
        # resize with arrowkeys
        "$mod CTRL, UP, resizeactive, 0 -20"
        "$mod CTRL, DOWN, resizeactive, 0 20"
        "$mod CTRL, LEFT, resizeactive, -20 0"
        "$mod CTRL, RIGHT, resizeactive, 20 0"
      ];

      bindl = [
        # media controls
        ", XF86AudioPlay, exec, playerctl play-pause"

        # volume
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindle = [
        # volume
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

        # backlight
        ", XF86MonBrightnessUp, exec, brillo -q -u 300000 -A 5"
        ", XF86MonBrightnessDown, exec, brillo -q -u 300000 -U 5"
      ];
    };
  };
}

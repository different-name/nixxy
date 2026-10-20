{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager =
      { config, osConfig, ... }:
      let
        inherit (config.lib.hyprland)
          mod
          bind
          bindWith
          exec
          ;

        uwsmCmd = lib.optionalString osConfig.programs.uwsm.enable "uwsm app -- ";
        uwsmApp = cmd: uwsmCmd + cmd;
        uwsmSingleApp = cmd: "pgrep ${cmd} || ${uwsmCmd + cmd}";

        workspaces = map toString (lib.range 1 9);
      in
      {
        wayland.windowManager.hyprland.settings.bind = [
          # use wev to find mouse button codes
          (bindWith { mouse = true; } "${mod} + mouse:272" "hl.dsp.window.drag()")
          (bindWith { mouse = true; } "${mod} + mouse:273" "hl.dsp.window.resize()")
          (bindWith { mouse = true; } "${mod} + CTRL + mouse:272" "hl.dsp.window.resize()")

          # compositor commands
          (bind "${mod} + Q" "hl.dsp.window.close()")
          (bind "${mod} + F" "hl.dsp.window.fullscreen_state({ internal = 2, client = -1 })") # fullscreen the window, don't inform the client it was fullscreened
          (bind "${mod} + SHIFT + F" "hl.dsp.window.fullscreen_state({ internal = -1, client = 2 })") # keep current fullscreen state, tell client it is fullscreened
          (bind "${mod} + R" ''hl.dsp.layout("togglesplit")'')
          (bind "${mod} + G" "hl.dsp.window.float()")
          (bind "${mod} + A" "hl.dsp.group.toggle()")
          (bind "${mod} + SHIFT + A" "hl.dsp.group.lock_active()")
          (bind "ALT + TAB" "hl.dsp.group.next()")
          (bind "ALT + SHIFT + TAB" "hl.dsp.group.prev()")
          (bind "${mod} + T" "hl.dsp.window.pin()")
          (bind "CTRL + ALT + DELETE" (exec (uwsmApp "hyprctl kill")))
          (bind "CTRL + ALT + SHIFT + DELETE" (
            exec ''systemctl --user stop wayland-wm@hyprland\\x2duwsm.desktop.service''
          ))

          # utility
          ## terminal
          (bind "${mod} + RETURN" (exec (uwsmApp "kitty")))
          ## lock screen
          (bind "${mod} + L" (exec (uwsmSingleApp "hyprlock")))
          ## launcher
          (bind "${mod} + S" (exec "vicinae toggle")) # not using uwsm as it introduces latency
          ## browser
          (bind "${mod} + W" (exec (uwsmApp "firefox")))
          ## file explorer
          (bind "${mod} + E" (exec (uwsmApp "thunar")))
          ## emoji picker
          (bind "${mod} + SHIFT + E" (exec (uwsmApp "emote")))

          # move focus
          (bind "${mod} + LEFT" ''hl.dsp.focus({ direction = "left" })'')
          (bind "${mod} + RIGHT" ''hl.dsp.focus({ direction = "right" })'')
          (bind "${mod} + UP" ''hl.dsp.focus({ direction = "up" })'')
          (bind "${mod} + DOWN" ''hl.dsp.focus({ direction = "down" })'')

          # swap windows
          (bind "${mod} + SHIFT + LEFT" ''hl.dsp.window.swap({ direction = "left" })'')
          (bind "${mod} + SHIFT + RIGHT" ''hl.dsp.window.swap({ direction = "right" })'')
          (bind "${mod} + SHIFT + UP" ''hl.dsp.window.swap({ direction = "up" })'')
          (bind "${mod} + SHIFT + DOWN" ''hl.dsp.window.swap({ direction = "down" })'')

          # screenshot
          ## area
          (bind "PRINT" (exec "${uwsmSingleApp "grimblast"} --notify copy area"))
          (bind "${mod} + SHIFT + S" (exec "${uwsmSingleApp "grimblast"} --notify copy area"))
          ## current screen
          (bind "CTRL + PRINT" (exec "${uwsmSingleApp "grimblast"} --notify --cursor copy output"))
          (bind "${mod} + SHIFT + CTRL + S" (
            exec "${uwsmSingleApp "grimblast"} --notify --cursor copy output"
          ))

          # cycle workspaces
          (bind "${mod} + bracketleft" ''hl.dsp.focus({ workspace = "m-1" })'')
          (bind "${mod} + bracketright" ''hl.dsp.focus({ workspace = "m+1" })'')
          (bind "mouse:275" ''hl.dsp.focus({ workspace = "m-1" })'') # two buttons on the side of my mouse
          (bind "mouse:276" ''hl.dsp.focus({ workspace = "m+1" })'')

          # cycle monitors
          (bind "${mod} + SHIFT + bracketleft" ''hl.dsp.focus({ monitor = "l" })'')
          (bind "${mod} + SHIFT + bracketright" ''hl.dsp.focus({ monitor = "r" })'')

          # send focused workspace to left/right monitors
          (bind "${mod} + SHIFT + ALT + bracketleft" ''hl.dsp.workspace.move({ monitor = "l" })'')
          (bind "${mod} + SHIFT + ALT + bracketright" ''hl.dsp.workspace.move({ monitor = "r" })'')

          # color picker
          (bind "${mod} + SHIFT + C" (exec "${uwsmSingleApp "hyprpicker"} --autocopy"))

          # display time as noficiation
          (bind "${mod} + D" (exec ''notify-send -t 5000 "$(date "+%a %-d %b %Y | %-I:%M%p")"''))

          # toggle mako dnd
          (bind "${mod} + SHIFT + D" (exec "mako-dnd"))

          # resize with arrowkeys
          (bindWith {
            repeating = true;
          } "${mod} + CTRL + UP" "hl.dsp.window.resize({ x = 0, y = -20, relative = true })")
          (bindWith {
            repeating = true;
          } "${mod} + CTRL + DOWN" "hl.dsp.window.resize({ x = 0, y = 20, relative = true })")
          (bindWith {
            repeating = true;
          } "${mod} + CTRL + LEFT" "hl.dsp.window.resize({ x = -20, y = 0, relative = true })")
          (bindWith {
            repeating = true;
          } "${mod} + CTRL + RIGHT" "hl.dsp.window.resize({ x = 20, y = 0, relative = true })")

          # cursor-aware brightness (hold to repeat, osd-brightness drops overlapping calls so ddc isn't overwhelmed)
          (bindWith { repeating = true; } "${mod} + PAGE_UP" (exec "osd-brightness up"))
          (bindWith { repeating = true; } "${mod} + PAGE_DOWN" (exec "osd-brightness down"))

          # media controls
          (bindWith { locked = true; } "XF86AudioPlay" (exec "playerctl play-pause"))

          # volume
          (bindWith { locked = true; } "XF86AudioMute" (exec "swayosd-client --output-volume mute-toggle"))
          (bindWith { locked = true; } "XF86AudioMicMute" (exec "swayosd-client --input-volume mute-toggle"))
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86AudioRaiseVolume" (exec "swayosd-client --output-volume 6 --max-volume 100"))
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86AudioLowerVolume" (exec "swayosd-client --output-volume -6 --max-volume 100"))

          # backlight
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86MonBrightnessUp" (exec "osd-brightness up"))
          (bindWith {
            locked = true;
            repeating = true;
          } "XF86MonBrightnessDown" (exec "osd-brightness down"))
        ]
        # workspace keys
        ++ map (ws: bind "${mod} + ${ws}" ''smw.workspace("${ws}")'') workspaces
        ++ map (ws: bind "${mod} + SHIFT + ${ws}" ''smw.move_to_workspace("${ws}")'') workspaces;
      };
  };
}

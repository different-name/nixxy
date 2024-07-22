{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    env = [
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
      "XCURSOR_SIZE,16"
    ];

    exec-once = [
      "nm-applet --indicator"
      "waybar"
      "dunst"
      "goxlr-daemon"
      "steam -silent"
    ];

    general = {
      gaps_in = 3;
      gaps_out = 6;
      "col.active_border" = "rgb(ed507c)";
      "col.inactive_border" = "rgba(18192688)";
    };

    decoration = {
      rounding = 5;
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.01;
        vibrancy = 0.2;
        vibrancy_darkness = 0.5;
        passes = 4;
        size = 7;
        popups = true;
        popups_ignorealpha = 0.2;
        new_optimizations = "on";
      };

      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_range = 8;
      shadow_render_power = 3;
      "col.shadow" = "rgba(00000055)";

      dim_inactive = false;
    };

    animations = {
      enabled = true;
      animation = [
        "border, 1, 2, default"
        "fade, 1, 4, default"
        "windows, 1, 3, default, popin 80%"
        "workspaces, 1, 2, default, slide"
      ];
    };

    input = {
      kb_layout = "us";

      accel_profile = "flat";
      touchpad = {
        natural_scroll = true;
        scroll_factor = 0.5;
        disable_while_typing = false;
      };
    };

    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };

    misc = {
      # disable auto polling for config file changes
      disable_autoreload = true;

      force_default_wallpaper = 0;

      no_direct_scanout = false;
    };

    # touchpad gestures
    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };

    # unscale xwayland
    xwayland.force_zero_scaling = true;

    experimental = {
      explicit_sync = true;
    };

    debug.disable_logs = false;

    plugin = {
      hyprexpo = {
        colimns = 3;
        gap_size = 4;
        bg_col = "rgb(000000)";

        enable_gesture = true;
        gesture_distance = 300;
        gesture_positive = false;
      };
    };

    monitor = [
      "desc:BNQ BenQ EW3270U 5BL00174019, preferred, 0x0, 1.5" # home monitor
      "desc:Valve Corporation ANX7530 U 0x00000001, preferred, 0x0, 1, transform, 3" # steam deck display
      "desc:Sharp Corporation 0x14D1, preferred, 0x0, 1.2" # laptop display
      ",preferred,auto,1" # everything else
    ];
  };
}

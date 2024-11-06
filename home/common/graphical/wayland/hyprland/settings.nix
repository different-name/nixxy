{
  lib,
  config,
  ...
}: let
  activeColor = "ed507c";
  inactiveColor = "181825";
  alternateColor = "cba6f7";
in {
  config = lib.mkIf config.nix-files.graphical.wayland.hyprland.enable {
    wayland.windowManager.hyprland.settings = {
      general = {
        gaps_in = 3;
        gaps_out = 6;
        "col.active_border" = "rgb(${activeColor})";
        "col.inactive_border" = "rgba(${inactiveColor}88)";
      };

      decoration = {
        rounding = 5;
        shadow = {
          range = 8;
          render_power = 3;
          ignore_window = true;
          color = "rgba(00000055)";
        };
        dim_inactive = false;
      };

      env = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "XCURSOR_SIZE,16"
      ];

      exec-once = [
        "goxlr-daemon"
        "steam -silent"
      ];

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

      cursor = {
        # workaround for grimblast area screenshots showing cursor
        # https://github.com/hyprwm/contrib/issues/60#issuecomment-2351538806
        allow_dumb_copy = true;
        # workaround for mouse being invisible in blender
        no_hardware_cursors = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        # disable auto polling for config file changes
        disable_autoreload = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      render.direct_scanout = false;

      # touchpad gestures
      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      group = {
        "col.border_active" = "rgb(${alternateColor})";
        "col.border_inactive" = "rgba(${inactiveColor}88)";
        "col.border_locked_active" = "rgb(${activeColor})";
        "col.border_locked_inactive" = "rgba(${inactiveColor}88)";
        groupbar = {
          height = 6;
          render_titles = false;
          "col.active" = "rgb(${alternateColor})";
          "col.inactive" = "rgb(${inactiveColor})";
          "col.locked_active" = "rgb(${activeColor})";
          "col.locked_inactive" = "rgb(${inactiveColor})";
        };
      };

      # unscale xwayland
      xwayland.force_zero_scaling = true;

      monitor = [
        "desc:BNQ BenQ EW3270U 5BL00174019, preferred, 0x0, 1.5" # home monitor
        ",preferred,auto,1" # everything else
      ];

      debug.disable_logs = false;
    };

    # TODO find or implement a way to do this through home-manager module
    xdg.configFile."hypr/xdph.conf" = {
      text = ''
        screencopy {
          allow_token_by_default = true
        }
      '';
    };
  };
}

{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    hm.wayland.windowManager.hyprland = {
      settings = {
        # keep-sorted start block=yes newline_separated=yes
        cursor = {
          # workaround for grimblast area screenshots showing cursor
          # https://github.com/hyprwm/contrib/issues/60#issuecomment-2351538806
          # allow_dumb_copy = true;
          # removed above in favor of https://github.com/hyprwm/Hyprland/issues/8424#issuecomment-2477328413
          use_cpu_buffer = true;
          # workaround for mouse being invisible in blender
          no_hardware_cursors = true;
        };

        debug.disable_logs = false;

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        env = [
          # keep-sorted start
          "GRIMBLAST_NO_CURSOR,0" # TODO https://github.com/fufexan/dotfiles/blob/27b78fa5e824ebcadcdb45509ca1e80aec40d50f/system/programs/hyprland/settings.nix#L11-L12
          "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          "XCURSOR_SIZE,16"
          # keep-sorted end
        ];

        gesture = [
          "3, left, workspace, m-1"
          "3, right, workspace, m+1"
        ];

        input = {
          kb_layout = "us";
          accel_profile = "flat";

          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.5;
            disable_while_typing = false;
          };
        };

        misc = {
          disable_autoreload = true; # disable auto polling for config file changes
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          anr_missed_pings = 10;
        };

        monitorv2 = [
          {
            # main monitor
            output = "desc:BNQ BenQ EX3210U ETA5R01980SL0";
            mode = "3840x2160@144";
            position = "0x0";
            scale = 1.5;
            bitdepth = 10;
          }
          {
            # second monitor
            output = "desc:Microstep MAG 244F BC4H015300312";
            mode = "1920x1080@200";
            position = "auto-right";
            scale = 1;
            transform = 3;
          }
          {
            # previous main monitor
            output = "desc:BNQ BenQ EW3270U 5BL00174019";
            mode = "preferred";
            position = "0x0";
            scale = 1.5;
          }
          {
            # everything else
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
          }
        ];

        render.direct_scanout = false;

        xwayland.force_zero_scaling = true;
        # keep-sorted end
      };

      xdgDesktopPortalHyprland.settings = {
        screencopy = {
          allow_token_by_default = true;
        };
      };
    };
  };
}

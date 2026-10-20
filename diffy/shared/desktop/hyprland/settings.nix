{ lib, config, ... }:
let
  inherit (config.dyad) applications;
in
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager =
      { config, ... }:
      let
        inherit (config.lib.hyprland) env;
      in
      {
        wayland.windowManager.hyprland = {
          settings = {
            config = {
              # keep-sorted start block=yes newline_separated=yes
              cursor = {
                # workaround for mouse being invisible in blender
                no_hardware_cursors = true;
              };

              debug.disable_logs = true;

              dwindle.preserve_split = true;

              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
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

              misc = {
                disable_autoreload = true; # disable auto polling for config file changes
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                anr_missed_pings = 10;
              };

              render.direct_scanout = false;

              xwayland.force_zero_scaling = true;
              # keep-sorted end
            };

            env = [
              # keep-sorted start
              (env "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1")
              (env "XCURSOR_SIZE" "16")
              # keep-sorted end
            ]
            ++ lib.optional applications.vscodium.enable (env "EDITOR" "codium --wait");

            gesture = lib.singleton {
              fingers = 3;
              direction = "horizontal";
              action = "workspace";
            };

            monitor = [
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
                # laptop monitor
                output = "desc:Sharp Corporation 0x14D1";
                mode = "preferred";
                position = "0x0";
                scale = 1.2;
              }
              {
                # work monitor
                output = "desc:Microstep MSI MP275 PC3M234705301";
                mode = "1920x1080@60";
                position = "auto-right";
                scale = 1;
              }
              {
                # previous main monitor
                output = "desc:BNQ BenQ EW3270U 0x00005445";
                mode = "2560x1440@60";
                position = "auto-right";
                scale = 1;
              }
              {
                # everything else
                output = "";
                mode = "preferred";
                position = "auto";
                scale = 1;
              }
            ];
          };

          xdgDesktopPortalHyprland.settings = {
            screencopy = {
              allow_token_by_default = true;
            };
          };
        };
      };
  };
}

{
  inputs,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland.packages."${pkgs.system}".hyprland;
  scaleFactor = "1.666667";
in {
  home.packages = [
    pkgs.libnotify
    pkgs.networkmanagerapplet
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      exec-once = [
        "nm-applet --indicator"
        "waybar"
        "dunst"
      ];

      env = [
        "GDK_SCALE,${scaleFactor}"
        "XCURSOR_SIZE,16"
      ];

      monitor = [
        "desc:Valve Corporation ANX7530 U 0x00000001, preferred, 0x0, 1, transform, 3"
        "desc:BNQ BenQ EW3270U 5BL00174019, preferred, 0x0, ${scaleFactor}"
        ",preferred,auto,1"
        "Unknown-1,disable"
      ];

      general = {
        resize_on_border = true;
        gaps_out = 10;
      };

      dwindle = {
        preserve_split = true;
      };

      input = {
        kb_layout = "us";
      };

      bind = let
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        mvfocus = binding "SUPER" "movefocus";
        ws = binding "SUPER" "workspace";
        resizeactive = binding "SUPER CTRL" "resizeactive";
        mvactive = binding "SUPER ALT" "moveactive";
        mvtows = binding "SUPER SHIFT" "movetoworkspace";
        arr = [1 2 3 4 5 6 7];
        runOnce = program: "pgrep ${program} || ${program}";
      in
        [
          "SUPER, S, exec, rofi -show drun -show-icons"
          "SUPER, Return, exec, kitty"
          "SUPER, W, exec, brave"
          "SUPER, E, exec, thunar"
          "CTRL ALT, Delete, exit"
          "ALT, Q, killactive"
          "SUPER, F, togglefloating"
          "SUPER, G, fullscreen"
          "SUPER, O, fakefullscreen"
          "SUPER, P, togglesplit"
          "SUPER_SHIFT, S, exec, ${runOnce "grimblast"} --notify copysave area"

          (mvfocus "up" "u")
          (mvfocus "down" "d")
          (mvfocus "right" "r")
          (mvfocus "left" "l")
          (ws "left" "e-1")
          (ws "right" "e+1")
          (mvtows "left" "e-1")
          (mvtows "right" "e+1")
          (resizeactive "up" "0 -20")
          (resizeactive "down" "0 20")
          (resizeactive "right" "20 0")
          (resizeactive "left" "-20 0")
          (mvactive "up" "0 -20")
          (mvactive "down" "0 20")
          (mvactive "right" "20 0")
          (mvactive "left" "-20 0")
        ]
        ++ (map (i: ws (toString i) (toString i)) arr)
        ++ (map (i: mvtows (toString i) (toString i)) arr);

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];

      decoration = {
        drop_shadow = "yes";
        shadow_range = 8;
        shadow_render_power = 2;

        rounding = 5;

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
          popups = true;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 5, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # unscale xwayland
      xwayland.force_zero_scaling = true;

      debug.disable_logs = false;
    };
  };
}

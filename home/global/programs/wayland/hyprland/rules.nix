{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = let
      fullscreenSteamApps = [
        438100 # vrchat
        1058830 # spin rhythm
      ];
    in
      [
        # gnome calculator
        "float, class:(qalculate-gtk)"
        "size 850 575, class:(qalculate-gtk)"

        # brave PiP
        "float, title:(Picture-in-picture)"
        "pin, title:(Picture-in-picture)"
        "size 480 270, title:(Picture-in-picture)"

        # gtk popups
        "float, class:(xdg-desktop-portal-gtk)"

        # pavucontrol
        "float, class:(pavucontrol)"
        "size 1000 750, class:(pavucontrol)"

        # thunar file operations
        "float, title:(File Operation Progress)"

        # vesktop sharescreen menu
        "float, title:(MainPicker)"
      ]
      ++ (lib.flatten (map (id: let
          idStr = toString id;
        in [
          "suppressevent maximize, class:(steam_app_${idStr})"
          "suppressevent fullscreen, class:(steam_app_${idStr})"
          "fullscreen, class:(steam_app_${idStr})"
        ])
        fullscreenSteamApps));
  };
}

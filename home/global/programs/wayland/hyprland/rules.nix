{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # global
      "suppressevent maximize, class:.*"

      # galculate
      "float, class:^(qalculate-gtk)$"
      "size 850 575, class:^(qalculate-gtk)$"

      # brave PiP
      "float, title:^(Picture-in-picture)$"
      "pin, title:^(Picture-in-picture)$"
      "size 480 270, title:^(Picture-in-picture)$"
      "keepaspectratio, title:^(Picture-in-picture)$"

      # gtk popups
      "float, class:^(xdg-desktop-portal-gtk)$"

      # pavucontrol
      "float, class:^(pavucontrol)$"
      "size 1000 750, class:^(pavucontrol)$"

      # hyprland share picker
      "float, title:^(MainPicker)$"

      # steam games
      "suppressevent fullscreen, class:^(steam_app_[0-9]*)$"
      "fullscreen, class:^(steam_app_[0-9]*)$"
      "workspace 2, class:^(steam_app_[0-9]*)$"
      # fix for various mouse issues
      # possibly related to https://github.com/hyprwm/Hyprland/issues/6543
      "stayfocused, class:^(steam_app_[0-9]*)$"
    ];
  };
}

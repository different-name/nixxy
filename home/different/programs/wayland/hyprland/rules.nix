{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    layerrule = let
      toRegex = list: let
        elements = lib.concatStringsSep "|" list;
      in "^(${elements})$";

      lowopacity = [
        "notifications"
      ];

      highopacity = [
      ];

      blurred = lib.concatLists [
        lowopacity
        highopacity
      ];
    in [
      "blur, ${toRegex blurred}"
      "ignorealpha 0.5, ${toRegex highopacity}"
      "ignorealpha 0.2, ${toRegex lowopacity}"
    ];

    windowrulev2 = [
      # gnome calculator
      "float, class:^(org.gnome.Calculator)$"
      "size 360 490, class:^(org.gnome.Calculator)$"

      # brave PiP
      "float, title:^(Picture-in-picture)"
      "pin, title:^(Picture-in-picture)"
    ];
  };
}

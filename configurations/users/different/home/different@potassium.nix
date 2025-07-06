{ lib, osConfig, ... }:
lib.mkIf (osConfig.dyad.host == "potassium") {
  ### dyad modules

  dyad = {
    ## profiles
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };
  };

  ### host specific

  # display battery as notification
  wayland.windowManager.hyprland.settings.bind = [
    ''$mod, B, exec, notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"''
  ];
}

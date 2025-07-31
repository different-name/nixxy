{ lib, osConfig, ... }:
lib.mkIf (osConfig.networking.hostName == "potassium") {
  dyad = {
    profiles = {
      # keep-sorted start
      graphical.enable = true;
      minimal.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    services.syncthing.enable = true;
  };

  # display battery as notification
  wayland.windowManager.hyprland.settings.bind = [
    ''$mod, B, exec, notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"''
  ];
}

{ lib, osConfig, ... }:
lib.mkIf (osConfig.networking.hostName == "potassium") {
  ### dyad modules

  dyad = {
    ## profiles
    profiles = {
      minimal.enable = true;
      terminal.enable = true;
      graphical.enable = true;
    };

    ## modules
    services.syncthing.enable = true;
  };

  ### host specific

  # display battery as notification
  wayland.windowManager.hyprland.settings.bind = [
    ''$mod, B, exec, notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"''
  ];
}

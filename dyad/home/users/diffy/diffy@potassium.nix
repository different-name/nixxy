{
  lib,
  config,
  osConfig,
  ...
}:
let
  inherit (config.home) username;
  inherit (osConfig.networking) hostName;
in
lib.mkIf (username == "diffy" && hostName == "potassium") {
  dyad = {
    profiles = {
      # keep-sorted start
      graphical-minimal.enable = true;
      graphical-extras.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    # keep-sorted start
    services.syncthing.enable = true;
    system.perpetual.enable = true;
    # keep-sorted end
  };

  # display battery as notification
  wayland.windowManager.hyprland.settings.bind = [
    ''$mod, B, exec, notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"''
  ];
}

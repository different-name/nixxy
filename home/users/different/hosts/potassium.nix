{ lib, config, ... }:
let
  cfg = config.nix-files.home;
in
lib.mkIf (cfg.user == "different" && cfg.host == "potassium") {
  ### nix-files modules

  nix-files = {
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

{
  imports = [
    ../.
  ];

  ### modules

  nix-files = {
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };

    graphical.meta.nvidia.enable = true;
  };

  ### host specific

  # display battery as notification
  wayland.windowManager.hyprland.settings.bind = [
    ''$mod, B, exec, cat /sys/class/power_supply/BAT0/capacity | xargs -I {} notify-send -t 5000 "Battery: {}%"''
  ];

  ### required config

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

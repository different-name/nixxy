{
  lib,
  config,
  osConfig,
  ...
}:
{
  config = lib.mkIf (config.nix-files.user == "different" && osConfig.nix-files.host == "potassium") {
    ### modules

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

    ### required config

    # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
  };
}

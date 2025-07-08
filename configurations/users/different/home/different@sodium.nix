{
  lib,
  osConfig,
  pkgs,
  ...
}:
lib.mkIf (osConfig.networking.hostName == "sodium") {
  ### dyad modules

  dyad = {
    ## profiles
    profiles = {
      minimal.enable = true;
      terminal.enable = true;
      graphical.enable = true;
    };

    ## modules
    media.goxlr-utility.enable = true;

    games.xr = {
      enable = true;

      # lower monitor resolution in vr mode & change mouse focus mode
      enterVrHook = ''
        hyprctl keyword monitor "desc:BNQ BenQ EW3270U 5BL00174019, 1920x1080, 0x0, 0.75"
        hyprctl keyword input:follow_mouse 2
      '';

      # defaults
      exitVrHook = ''
        hyprctl keyword monitor "desc:BNQ BenQ EW3270U 5BL00174019, preferred, 0x0, 1.5"
        hyprctl keyword input:follow_mouse 1
      '';
    };
  };

  ### host specific

  programs.btop.settings.cpu_sensor = "k10temp/Tctl";

  home.packages = with pkgs; [
    qmk
  ];

  # persist syncthing configuration
  dyad.system.persistence.dirs = [
    ".config/syncthing"
  ];
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nix-files.home;
in
lib.mkIf (cfg.user == "different" && cfg.host == "sodium") {
  ### nix-files modules

  nix-files = {
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };

    parts = {
      media = {
        goxlr-utility.enable = true;
      };

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
  };

  ### host specific

  programs.btop.settings.cpu_sensor = "k10temp/Tctl";

  # persist syncthing configuration
  nix-files.parts.system.persistence = {
    directories = [
      ".config/syncthing"
    ];
  };

  home.packages = with pkgs; [
    qmk
  ];
}

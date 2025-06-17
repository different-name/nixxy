{
  lib,
  config,
  osConfig,
  ...
}:
{
  config = lib.mkIf (config.nix-files.user == "different" && osConfig.nix-files.host == "sodium") {
    ### modules

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

    ### required config

    # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "24.05";
  };
}

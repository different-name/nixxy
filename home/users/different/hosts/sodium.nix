{
  config,
  lib,
  ...
}: {
  imports = [
    ../.
  ];

  ### modules

  nix-files = {
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };

    graphical.games.xr = {
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

    graphical.meta.nvidia.enable = true;

    services.goxlr-utility.enable = true;
  };

  ### host specific

  programs.btop.settings.cpu_sensor = "k10temp/Tctl";

  # goxlr / tascam

  # home.packages = [
  #   self.packages.${pkgs.system}.tascam
  # ];

  # wayland.windowManager.hyprland.settings.bind = [
  #   "$mod, P, exec, pgrep tascam || tascam"
  # ];

  # persist syncthing configuration

  home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
    directories = [
      ".config/syncthing"
    ];
  };

  ### required config

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}

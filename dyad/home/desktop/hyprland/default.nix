{
  lib,
  config,
  inputs,
  inputs',
  self,
  osConfig,
  ...
}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    self.homeModules.xdgDesktopPortalHyprland
  ];

  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      package = inputs'.hyprland.packages.hyprland;

      systemd = {
        enable = !osConfig.programs.uwsm.enable; # conflicts with uwsm
        variables = [ "--all" ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      };

      xwayland.enable = true;
    };

    services.hyprpolkitagent.enable = true;

    home.packages = with inputs'; [
      # keep-sorted start
      hyprland-contrib.packages.grimblast
      hyprpicker.packages.default
      # keep-sorted end
    ];

    dyad.system.persistence.dirs = [
      # keep-sorted start
      ".cache/hyprland"
      ".local/share/hyprland"
      # keep-sorted end
    ];
  };
}

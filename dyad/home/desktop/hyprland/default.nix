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
    self.homeManagerModules.xdgDesktopPortalHyprland
  ];

  options.dyad.desktop.hyprland.enable = lib.mkEnableOption "hyprland config";

  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home.packages = with inputs'; [
      hyprland-contrib.packages.grimblast
      hyprpicker.packages.default
    ];

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

    dyad.system.persistence = {
      directories = [
        ".cache/hyprland"
        ".local/share/hyprland"
      ];
    };
  };
}

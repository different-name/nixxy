{
  lib,
  config,
  inputs,
  pkgs,
  osConfig,
  ...
}:
{
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.self.homeManagerModules.xdg-desktop-portal-hyprland
  ];

  options.nix-files.parts.desktop.hyprland.enable = lib.mkEnableOption "Hyprland config";

  config = lib.mkIf config.nix-files.parts.desktop.hyprland.enable {
    home.packages = with inputs; [
      hyprland-contrib.packages.${pkgs.system}.grimblast
      hyprpicker.packages.${pkgs.system}.default
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      package = inputs.hyprland.packages."${pkgs.system}".hyprland;

      systemd = {
        enable = !osConfig.programs.uwsm.enable; # conflicts with uwsm
        variables = [ "--all" ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      };

      xwayland.enable = true;
    };

    services.hyprpolkitagent.enable = true;

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".cache/hyprland"
        ".local/share/hyprland"
      ];
    };
  };
}

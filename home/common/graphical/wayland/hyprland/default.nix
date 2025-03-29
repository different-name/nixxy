{
  lib,
  config,
  inputs,
  pkgs,
  osConfig,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default

    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  options.nix-files.graphical.wayland.hyprland.enable = lib.mkEnableOption "Hyprland config";

  config = lib.mkIf config.nix-files.graphical.wayland.hyprland.enable {
    home.packages = with inputs; [
      hyprland-contrib.packages.${pkgs.system}.grimblast
      hyprpicker.packages.${pkgs.system}.default
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      package = inputs.hyprland.packages."${pkgs.system}".hyprland;

      systemd = {
        enable = !osConfig.programs.uwsm.enable; # conflicts with uwsm
        variables = ["--all"]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
      };

      xwayland.enable = true;
    };

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/hyprland"
      ];
    };

    programs.fish.shellAliases = {
      monitorlowres = ''        hyprctl keyword monitor "desc:BNQ BenQ EW3270U 5BL00174019, 1920x1080, 0x0, 0
                .75"'';
      monitorres = ''hyprctl keyword monitor "desc:BNQ BenQ EW3270U 5BL00174019, preferred, 0x0, 1.5"'';
    };
  };
}

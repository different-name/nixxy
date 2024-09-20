{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./rofi.nix
  ];

  options.nix-files.graphical.wayland.enable = lib.mkEnableOption "Games packages";

  config = lib.mkIf config.nix-files.graphical.wayland.enable {
    home.packages = with pkgs; [
      pavucontrol
      wl-clipboard
      libnotify
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # pavucontrol
        ".local/state/wireplumber" # audio settings
      ];
    };
  };
}

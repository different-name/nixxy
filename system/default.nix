{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./core
    ./nix
    ./network

    ./hardware/graphics.nix
    ./hardware/fwupd.nix
    ./hardware/fstrim.nix
    ./hardware/bluetooth.nix

    ./programs
    ./programs/fonts.nix
    ./programs/home-manager.nix
    ./programs/xdg.nix
    ./programs/fish.nix
    ./programs/catppuccin.nix
    ./programs/gamemode.nix
    ./programs/hyprland.nix
    ./programs/steam.nix
    ./programs/seahorse.nix
    ./programs/adb.nix
    ./programs/thunar.nix

    ./services
    ./services/pipewire.nix
    ./services/gvfs.nix
    ./services/tumbler.nix
    ./services/keyd.nix
  ];

  environment.systemPackages = [
    outputs.packages.${pkgs.system}.openvr-advanced-settings
  ];
}

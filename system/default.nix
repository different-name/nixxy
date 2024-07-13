{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./core/boot.nix
    ./core/locale.nix
    ./core/persistence.nix
    ./core/security.nix
    ./core/users.nix
    ./core/zfs.nix

    ./nix
    ./network

    ./hardware/graphics.nix
    ./hardware/fwupd.nix
    ./hardware/fstrim.nix
    ./hardware/bluetooth.nix

    ./programs
    ./programs/fonts.nix
    ./programs/home-manager.nix
    ./programs/fish.nix
    ./programs/catppuccin.nix
    ./programs/gamemode.nix
    ./programs/steam.nix
    ./programs/adb.nix
    ./programs/fd.nix

    ./services/plasma.nix
    ./services/pipewire.nix
    ./services/keyd.nix
    ./services/printing.nix
    ./services/openssh.nix
  ];

  environment.systemPackages = [
    outputs.packages.${pkgs.system}.openvr-advanced-settings
  ];
}

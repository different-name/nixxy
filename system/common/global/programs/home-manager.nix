{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # needed for home-manager impermanence to mount it's directories
  programs.fuse.userAllowOther = true;
}

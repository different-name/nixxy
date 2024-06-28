{
  inputs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # Needed for HM impermanence to mount it's directories
  programs.fuse.userAllowOther = true;

  # Setting up home directories with correct permissions for HM impermanence
  systemd.tmpfiles.rules = [
    "d /persist/home/ 1777 root root -"
    "d /persist/home/different 0700 different users -"
  ];
}

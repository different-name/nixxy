{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # workaround https://github.com/nix-community/home-manager/issues/4199#issuecomment-2226810699
  # home-manager.backupFileExtension = "backup";
  # system.userActivationScripts = {
  #   removeConflictingFiles = {
  #     text = ''
  #       rm -f /home/different/.gtkrc-2.0.backup
  #     '';
  #   };
  # };

  # Needed for HM impermanence to mount it's directories
  programs.fuse.userAllowOther = true;

  # Setting up home directories with correct permissions for HM impermanence
  systemd.tmpfiles.rules = [
    "d /persist/home/ 1777 root root -"
    "d /persist/home/different 0700 different users -"
    "d /home/different/.local 0755 different users -"
    "d /home/different/.local/share 0755 different users -"
  ];
}

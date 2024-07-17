{
  inputs,
  config,
  ...
}: let
  inherit (config.nix-files) user;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  # workaround https://github.com/nix-community/home-manager/issues/4199#issuecomment-2226810699
  # home-manager.backupFileExtension = "backup";
  # system.userActivationScripts = {
  #   removeConflictingFiles = {
  #     text = ''
  #       rm -f /home/${user}/.gtkrc-2.0.backup
  #     '';
  #   };
  # };

  # needed for home-manager impermanence to mount it's directories
  programs.fuse.userAllowOther = true;

  # setting up home directories with correct permissions for home-manager impermanence
  systemd.tmpfiles.rules = [
    "d /persist/home/ 1777 root root -"
    "d /persist/home/${user} 0700 ${user} users -"
  ];
}

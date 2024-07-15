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

  # needed for HM impermanence to mount it's directories
  programs.fuse.userAllowOther = true;

  # setting up home directories with correct permissions for HM impermanence
  systemd.tmpfiles.rules = [
    "d /persist/home/ 1777 root root -"
    "d /persist/home/${user} 0700 ${user} users -"

    # TODO these are just for the steam mounts, there is probably a better place to move these
    "d /home/${user}/.steam 0755 ${user} users -"
    "d /home/${user}/.local 0755 ${user} users -"
    "d /home/${user}/.local/share 0755 ${user} users -"
    "d /home/${user}/.local/share/Steam 0755 ${user} users -"
  ];
}

{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist/system" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/zfs/keys"
    ];

    files = [];
  };

  # needed for home-manager impermanence to mount it's directories
  programs.fuse.userAllowOther = true;
}

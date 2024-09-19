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
      "/root/.cache"
      "/var/cache"
      "/var/lib/systemd/timesync"
    ];

    files = [
      "/var/lib/logrotate.status"
      "/var/lib/systemd/random-seed"
    ];
  };

  # needed for home-manager impermanence to mount it's directories
  programs.fuse.userAllowOther = true;
}

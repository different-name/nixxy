{
  lib,
  writeShellApplication,
  cryptsetup,
  btrfs-progs,
  pv,
  udisks,
  backupConfig ? { },
  ...
}:
writeShellApplication {
  name = "btrfs-backup";
  runtimeInputs = [
    cryptsetup
    btrfs-progs
    pv
    udisks
  ];

  text = ''
    UUID="${backupConfig.backupDiskUuid}"
    CRYPT_NAME="${backupConfig.cryptName}"
    MOUNT_POINT="${backupConfig.mountPoint}"
    SNAPSHOT_DIR="${builtins.dirOf backupConfig.subvolumePath}"
    SOURCE_SUBVOL="${backupConfig.subvolumePath}"

    ${builtins.readFile ./btrfs-backup.sh}
  '';

  meta = {
    description = "Little backup script for my BTRFS persistent subvolume";
    maintainers = with lib.maintainers; [ different-name ];
  };
}

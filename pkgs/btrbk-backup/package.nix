{
  lib,
  writeShellApplication,
  replaceVars,
  cryptsetup,
  btrfs-progs,
  pv,
  udisks,
  btrbk,
  backupConfig ? { },
}:
writeShellApplication {
  name = "btrbk-backup";
  runtimeInputs = [
    cryptsetup
    btrfs-progs
    pv
    udisks
    btrbk
  ];

  text = builtins.readFile (
    replaceVars ./btrbk-backup.sh {
      uuid = backupConfig.backupDiskUuid;
      crypt_name = backupConfig.cryptName;
      mount_point = backupConfig.mountPoint;
      config_path = backupConfig.configPath;
    }
  );

  meta = {
    description = "Little backup script for my BTRFS persistent subvolume";
    maintainers = with lib.maintainers; [ different-name ];
  };
}

{ bundleLib, self, ... }:
let
  box = "u696311.your-storagebox.de";
  subAccounts = {
    sodium = "u696311-sub1";
    potassium = "u696311-sub2";
    argon = "u696311-sub3";
  };
in
bundleLib.mkEnableModule [ "dyad" "services" "backup" ] {
  nixos =
    { config, ... }:
    let
      host = config.networking.hostName;
      user = subAccounts.${host};
      home = "/persist/home/diffy";
    in
    {
      age.secrets."restic/${host}".file = self + /diffy/secrets/restic/${host}.age;

      programs.ssh.knownHosts.xenon = {
        hostNames = [ "[${box}]:23" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIICf9svRenC/PLKIL9nk6K/pxQgoiFC41wTNvoIncOxs";
      };

      services.restic.backups.xenon = {
        repository = "sftp:${user}@${box}:restic";
        # the sub-account only accepts this host's ssh key
        extraOptions = [
          "sftp.command='ssh -p 23 -i /etc/ssh/ssh_host_ed25519_key ${user}@${box} -s sftp'"
        ];
        passwordFile = config.age.secrets."restic/${host}".path;
        initialize = true;

        paths = [ "/persist" ];
        exclude = [
          "${home}/Documents/Unity/*/Library"
          "${home}/Documents/Unity/*/Temp"
          "${home}/Documents/Unity/*/obj"
          "${home}/Documents/Unity/*/Logs"
          "**/.Trash-*"
        ];
        # the volatile store's bind mounts propagate back under /persist
        extraBackupArgs = [
          "--exclude-caches"
          "--one-file-system"
        ];

        timerConfig = {
          OnCalendar = "04:00";
          RandomizedDelaySec = "1h";
          Persistent = true;
        };

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 4"
          "--keep-monthly 6"
        ];
      };
    };
}

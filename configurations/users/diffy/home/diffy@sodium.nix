{
  lib,
  osConfig,
  self',
  pkgs,
  ...
}:
lib.mkIf (osConfig.networking.hostName == "sodium") {
  dyad = {
    profiles = {
      # keep-sorted start
      graphical.enable = true;
      minimal.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    # keep-sorted start block=yes newline_separated=yes
    games.xr = {
      enable = true;
      # lower monitor resolution in vr mode & change mouse focus mode
      enterVrHook = ''
        hyprctl keyword input:follow_mouse 2
      '';
      # restore defaults
      exitVrHook = ''
        hyprctl keyword input:follow_mouse 1
      '';
    };

    media.goxlr-utility.enable = true;

    services.syncthing.enable = true;
    # keep-sorted end
  };

  programs.btop.settings.cpu_sensor = "k10temp/Tctl";

  home.packages = [
    # keep-sorted start block=yes
    (self'.packages.btrfs-backup.override {
      backupConfig = {
        backupDiskUuid = "a5091625-835c-492f-8d99-0fc8d27012a0";
        cryptName = "backup_drive";
        mountPoint = "/mnt/backup";
        subvolumePath = "/btrfs/persist";
      };
    })
    pkgs.qmk
    # keep-sorted end
  ];
}

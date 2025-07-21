{
  lib,
  osConfig,
  self',
  pkgs,
  ...
}:
lib.mkIf (osConfig.networking.hostName == "sodium") {
  ### dyad modules

  dyad = {
    ## profiles
    profiles = {
      minimal.enable = true;
      terminal.enable = true;
      graphical.enable = true;
    };

    ## modules
    media.goxlr-utility.enable = true;

    games.xr = {
      enable = true;

      # lower monitor resolution in vr mode & change mouse focus mode
      enterVrHook = ''
        hyprctl keyword input:follow_mouse 2
      '';

      # defaults
      exitVrHook = ''
        hyprctl keyword input:follow_mouse 1
      '';
    };

    services.syncthing.enable = true;
  };

  ### host specific

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

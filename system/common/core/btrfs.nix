{
  lib,
  config,
  ...
}: {
  options.nix-files.core.btrfs.enable = lib.mkEnableOption "btrfs config";

  config = lib.mkIf config.nix-files.core.btrfs.enable {
    boot.initrd.systemd = {
      enable = true;
      services.root-subvol-switch = {
        description = "Switch btrfs root subvolume";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          "systemd-cryptsetup@rootfs.service"
        ];
        requires = [
          "systemd-cryptsetup@rootfs.service"
        ];
        before = [
          "sysroot.mount"
        ];
        # requires = ["initrd-root-device.target"];
        # after = ["local-fs-pre.target" "initrd-root-device.target"];
        # requiredBy = ["initrd-root-fs.target"];
        # before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir -p /btrfs
          mount -t btrfs -o subvol=/ ${config.fileSystems."/".device} /btrfs

          if [[ -e /btrfs/root/current ]]; then
            timestamp=$(date --date="@$(stat -c %Y /btrfs/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs/root/current "/btrfs/root/$timestamp"
          fi

          btrfs subvolume create /btrfs/root/current

          umount /btrfs
        '';
      };
    };

    # systemd.services.root-subvol-cleanup = let
    #   keepAtLeast = 5;
    #   cutoffDate = "30 days ago";
    # in {
    #   description = "Btrfs root subvolume cleaner";
    #   startAt = "daily";
    #   script = ''

    #   '';
    # };

    services.fstrim.enable = true;
  };
}

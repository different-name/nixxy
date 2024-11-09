{
  lib,
  config,
  # pkgs,
  ...
}: {
  options.nix-files.core.btrfs.enable = lib.mkEnableOption "btrfs config";

  config = lib.mkIf config.nix-files.core.btrfs.enable {
    # boot.initrd.systemd.services.root-subvol-switch = {
    #   description = "switch root subvolume";
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #   };
    #   requires = ["dev-mapper-foo.device"];
    #   after = ["dev-mapper-foo.device"];
    #   wantedBy = ["initrd.target"];
    #   path = with pkgs; [btrfs-progs];
    #   script = ''
    #     waitDevice ${config.fileSystems."/".device}

    #     mkdir -p /btrfs
    #     mount ${config.fileSystems."/".device} /btrfs

    #     if [ -e /btrfs/root/current ]; then
    #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
    #       mv /btrfs/root/current "/btrfs/root/$timestamp"
    #     fi

    #     btrfs subvolume create /mnt/root/current

    #     umount /btrfs
    #     rmdir /btrfs
    #   '';
    # };

    # systemd.services.root-subvol-cleanup = let
    #   keepAtLeast = 5;
    #   cutoffDate = "30 days ago";
    # in {
    #   description = "root subvolume cleaner";
    #   startAt = "daily";
    #   script = ''

    #   '';
    # };

    services.fstrim.enable = true;
  };
}

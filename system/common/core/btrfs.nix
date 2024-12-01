{
  lib,
  config,
  ...
}: {
  options.nix-files.core.btrfs.enable = lib.mkEnableOption "btrfs config";

  config = lib.mkIf config.nix-files.core.btrfs.enable {
    # https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/3
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

    # TODO
    # https://github.com/tejing1/nixos-config/blob/2cfac430ecddcc0b6d9606fb09889f0226b32c8c/nixosConfigurations/tejingdesk/optin-state.nix#L67-L92
    # systemd.services.root-subvol-cleanup = let
    #   keepAtLeast = 5;
    #   keepFrom = "30 days ago";
    # in {
    #   description = "Btrfs root subvolume cleaner";
    #   startAt = "daily";
    #   script = ''
    #   '';
    # };

    services.fstrim.enable = true;
  };
}

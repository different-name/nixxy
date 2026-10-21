{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "secure-boot" ] {
  nixos = { pkgs, ... }: {
    # tpm2 + pin, the passphrase slot stays as the fallback
    boot.initrd.luks.devices.rootfs.crypttabExtraOpts = [ "tpm2-device=auto" ];

    environment.systemPackages = [ pkgs.sbctl ];

    # regenerated keys would not match the ones enrolled in the firmware
    keep.persist.dirs."/var/lib/sbctl" = { };
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "secure-boot" ] {
  nixos = { pkgs, ... }: {
    # tpm2 + pin, the passphrase slot stays as the fallback
    boot.initrd.luks.devices.rootfs.crypttabExtraOpts = [ "tpm2-device=auto" ];

    # needs the sbctl keys enrolled in this machine's firmware
    boot.loader.limine.secureBoot.enable = true;

    environment.systemPackages = [ pkgs.sbctl ];

    # regenerated keys would not match the ones enrolled in the firmware
    keep.safe.dirs = [ "/var/lib/sbctl" ];
  };
}

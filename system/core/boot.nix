{
  pkgs,
  config,
  ...
}: {
  boot = {
    initrd = {
      # enable systemd in initial ramdisk
      systemd.enable = true;
      # ensure human input devices are functioning
      # need keyboard input to enter passphrase
      availableKernelModules = ["hid_generic"];
    };

    # newest kernels might not be supported by ZFS
    # use the latest compatible kernel:
    kernelPackages = pkgs.linuxPackages_zen; # config.boot.zfs.package.latestCompatibleLinuxPackages;

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # Skip boot options after 3 seconds
      timeout = 3;
    };

    supportedFilesystems = ["ntfs"];
  };
}

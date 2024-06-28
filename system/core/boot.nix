{ pkgs, config, ... }: {
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
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

    # https://wiki.archlinux.org/title/Silent_boot
    # consoleLogLevel = 3;
    # kernelParams = [
    #   "quiet" # disable most log messages
    #   "systemd.show_status=false" # disable systemd messages during initrd init
    #   "rd.udev.log_level=3" # log level to 3 + disable systemd printing version num
    # ];

    # graphical boot splash
    # plymouth.enable = true;

    loader = {
      # systemd-boot on UEFI
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # Skip boot options after 3 seconds
      timeout = 3;
    };

    supportedFilesystems = [ "ntfs" ];
  };
}

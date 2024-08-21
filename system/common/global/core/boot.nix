{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # disko is required for boot & mounting
    inputs.disko.nixosModules.default
  ];

  boot = {
    initrd = {
      # enable systemd in initial ramdisk
      systemd.enable = true;
      # ensure human input devices are functioning
      # need keyboard input to enter passphrase
      availableKernelModules = ["hid_generic"];
    };

    # zen kernel resolved issue with extra non-existent monitor appearing
    kernelPackages = pkgs.linuxPackages_zen;

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

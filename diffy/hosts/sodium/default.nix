{ inputs, ... }: {
  dyad = {
    host = {
      machineId = "9471422d94d34bb8807903179fb35f11";
      stateVersion = "26.05";
    };

    users.diffy.enable = true;

    profiles.graphical.enable = true;

    services.backup.enable = true;

    system.secure-boot.enable = true;

    applications.orca-slicer.enable = true;

    hardware.nvidia.enable = true;

    system = {
      btrfs.enable = true;
      keep.enable = true;
    };

    nix.build-machine.enable = true;

    games = {
      xr.enable = true;
      avatar-tools.enable = true;
    };

    media.goxlr-utility.enable = true;

  };

  nixos = {
    # needs the sbctl keys enrolled in this machine's firmware
    boot.loader.limine.secureBoot.enable = true;

    fileSystems."/scratch".neededForBoot = true;

    imports = [
      ./_disko.nix
      inputs.nixos-hardware.nixosModules.common-cpu-amd
    ];

    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-amd" ];
    hardware.enableRedistributableFirmware = true;

    environment.sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
      GDK_SCALE = "2";
    };

    programs.steam.gamescopeSession.args = [
      "-W"
      "3840"
      "-H"
      "2160"
      "-r"
      "144"
      "-f"
      "--hdr-enabled"
      "--prefer-output"
      "HDMI-A-1"
    ];
  };

  home-manager.programs.btop.settings.cpu_sensor = "k10temp/Tctl";
}

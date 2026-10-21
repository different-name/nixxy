{ inputs, ... }: {
  dyad = {
    host = {
      machineId = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
      stateVersion = "26.05";
    };

    users.diffy.enable = true;

    profiles.graphical.enable = true;

    services.backup.enable = true;

    system.secure-boot.enable = true;

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };

    applications.discord.autoStart = false;

    nix.sodium-builder.enable = true;

    services = {
      printing.enable = true;
    };
  };

  nixos = {
    imports = [
      # keep-sorted start
      (inputs.import-tree ./_nixos)
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      # keep-sorted end
    ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "rtsx_pci_sdmmc"
    ];
    boot.kernelModules = [ "kvm-intel" ];
    hardware.enableRedistributableFirmware = true;

    # laptop joins untrusted networks, ssh only over the tailnet
    services.openssh.openFirewall = false;
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

    services.thermald = {
      enable = true;
      # generated for the xps 15 9500, thermald has no default for it
      configFile = "${inputs.nixos-hardware}/dell/xps/15-9500/thermald-conf.xml";
    };
  };

  home-manager =
    { config, ... }:
    let
      inherit (config.lib.hyprland) mod bind exec;
    in
    {
      # display battery as notification
      wayland.windowManager.hyprland.settings.bind = [
        (bind "${mod} + B" (
          exec ''notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"''
        ))
      ];
    };
}

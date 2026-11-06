{ inputs, ... }: {
  dyad = {
    host = {
      machineId = "f973333893a548168337a2a8c258685b";
      stateVersion = "26.11";
    };

    users.diffy.enable = true;

    profiles.graphical.enable = true;

    services.backup.enable = true;

    hardware = {
      battery.enable = true;
      bluetooth.enable = true;
    };

    system = {
      btrfs.enable = true;
      keep.enable = true;
      secure-boot.enable = true;
    };

    nix.sodium-builder.enable = true;

    services = {
      printing.enable = true;
    };
  };

  nixos = { lib, pkgs, ... }: {
    fileSystems."/scratch".neededForBoot = true;

    imports = [
      # keep-sorted start
      ./_disko.nix
      inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      # keep-sorted end
    ];

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "sd_mod"
    ];
    boot.kernelModules = [ "kvm-intel" ];
    hardware.enableRedistributableFirmware = true;
    # framework-laptop-kmod ships no .ko.cer, which the modules tree now requires
    hardware.framework.enableKmod = false;

    # the ec ignores cros_charge_control, only its own charge limit command works
    systemd.services.charge-limit = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe' pkgs.framework-tool "framework_tool"} --charge-limit 80";
      };
    };

    keep.safe.dirs = [ "/var/lib/fprint" ];

    # laptop joins untrusted networks, ssh only over the tailnet
    services.openssh.openFirewall = false;
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
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
          exec ''notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT*/capacity)%"''
        ))
      ];
    };
}

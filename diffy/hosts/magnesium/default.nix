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
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.lib.hyprland) mod bind exec;

      osdBattery = pkgs.writeShellApplication {
        name = "osd-battery";
        runtimeInputs = [ pkgs.swayosd ];
        text = ''
          bat=/sys/class/power_supply/BAT1
          capacity=$(<"$bat/capacity")
          status=$(<"$bat/status")

          level=$((capacity / 10 * 10))
          case "$status" in
          Full) icon=battery-level-100-charged-symbolic ;;
          Charging) icon=battery-level-$level-charging-symbolic ;;
          *) icon=battery-level-$level-symbolic ;;
          esac
          # papirus has no 100-charging icon
          [ "$icon" = battery-level-100-charging-symbolic ] && icon=battery-level-100-charged-symbolic

          progress=1
          [ "$capacity" -lt 100 ] && progress=$(printf '0.%02d' "$capacity")

          swayosd-client --custom-icon "$icon" \
            --custom-progress "$progress" --custom-progress-text "$capacity%"
        '';
      };
    in
    {
      wayland.windowManager.hyprland.settings.bind = [
        (bind "${mod} + B" (exec (lib.getExe osdBattery)))
      ];
    };
}

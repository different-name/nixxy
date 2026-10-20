{ lib, inputs, ... }:
let
  machineId = "374afff124794b54c4670b774254545c";
in
{
  dyad = {
    users.diffy.enable = true;

    profiles = {
      # keep-sorted start
      minimal.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    # overrides profile defaults
    hardware.fwupd.enable = false;

    system = {
      btrfs.enable = true;
      networking.enable = false;
      perpetual.enable = true;
    };
  };

  nixos = { pkgs, ... }: {
    imports = [ (inputs.import-tree ./_nixos) ];

    system.stateVersion = "26.11";

    networking = {
      hostName = "argon";
      hostId = lib.substring 0 8 machineId;
      useDHCP = false;
      useNetworkd = true;
      nameservers = [
        "43.229.61.2"
        "43.229.62.2"
      ];
    };

    systemd.network.networks."10-wan" = {
      matchConfig.MACAddress = "00:16:3e:ea:77:41";
      address = [ "66.226.150.79/24" ];
      routes = lib.singleton { Gateway = "66.226.150.1"; };
    };

    environment.etc.machine-id.text = machineId;

    # ssh only over the tailnet, the binarylane console is the fallback
    services.openssh.openFirewall = false;
    services.tailscale.openFirewall = true;
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

    # zen is tuned for desktop latency
    boot.kernelPackages = pkgs.linuxPackages;

    boot.loader.limine = {
      efiSupport = false;
      biosDevice = "/dev/vda";
      # the bios boot partition in disko.nix
      partitionIndex = 1;
    };
  };
}

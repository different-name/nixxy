{ lib, inputs, ... }: {
  dyad = {
    host = {
      machineId = "374afff124794b54c4670b774254545c";
      stateVersion = "26.11";
    };

    users.diffy.enable = true;

    profiles.minimal.enable = true;

    services = {
      headscale.enable = true;
      webdav.enable = true;
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };
  };

  nixos = { pkgs, ... }: {
    imports = [ (inputs.import-tree ./_nixos) ];

    networking = {
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

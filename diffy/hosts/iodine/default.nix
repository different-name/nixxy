{ lib, inputs, ... }:
let
  machineId = "294b0aee9a634611a9ddef5e843f4035";
in
{
  dyad = {
    users.diffy.enable = true;

    profiles = {
      minimal.enable = true;
      terminal.enable = true;
    };

    services = {
      caddy.enable = true;
      cloudflare-dyndns.enable = true;
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };
  };

  nixos = {
    imports = [
      # keep-sorted start
      (inputs.import-tree ./_nixos)
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      # keep-sorted end
    ];

    config = {
      networking = {
        hostName = "iodine";
        hostId = lib.substring 0 8 machineId;
      };

      environment.etc.machine-id.text = machineId;

      system.stateVersion = "24.05";

      nix = {
        distributedBuilds = true;
        buildMachines = lib.singleton {
          hostName = "sodium";
          system = "x86_64-linux";
          maxJobs = 3;
          speedFactor = 2;
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ];
          mandatoryFeatures = [ ];
        };
      };
    };
  };
}

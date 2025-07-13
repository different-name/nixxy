{ inputs, self, ... }:
self.lib.mkHost
  {
    hostName = "potassium";
    machineId = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
    stateVersion = "24.05";
  }
  {
    imports = [
      ./hardware.nix
      ./disko.nix

      # keep-sorted start
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      self.nixosModules.tty1Autologin
      # keep-sorted end
    ];

    ### dyad modules

    dyad = {
      ## users
      users.diffy.enable = true;

      ## profiles
      profiles = {
        # keep-sorted start
        graphical.enable = true;
        laptop.enable = true;
        minimal.enable = true;
        terminal.enable = true;
        # keep-sorted end
      };

      ## modules
      # keep-sorted start block=yes newline_separated=yes
      hardware.nvidia.enable = true;

      nix.distributed-builds.enable = true;

      services.syncthing.enable = true;
      # keep-sorted end
    };

    ### host specific

    services.tty1Autologin = {
      enable = true;
      user = "diffy";
    };

    hardware.nvidia.prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  }

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
      inputs.nixos-hardware.nixosModules.dell-xps-15-9500-nvidia
      self.nixosModules.tty1Autologin
      # keep-sorted end
    ];

    ### dyad modules

    age.secrets = {
      "different/syncthing/potassium/key".file = self + /secrets/different/syncthing/potassium/key.age;
      "different/syncthing/potassium/cert".file = self + /secrets/different/syncthing/potassium/cert.age;
    };

    dyad = {
      ## users
      users.different.enable = true;

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
      user = "different";
    };

    hardware.nvidia.prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  }

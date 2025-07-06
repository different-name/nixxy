{
  config,
  inputs,
  self,
  ...
}:
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

      inputs.nixos-hardware.nixosModules.dell-xps-15-9500-nvidia
    ];

    ### dyad modules

    age.secrets = {
      "syncthing/potassium/key".file = self + /secrets/syncthing/potassium/key.age;
      "syncthing/potassium/cert".file = self + /secrets/syncthing/potassium/cert.age;
    };

    dyad = {
      ## users
      users.different.enable = true;

      ## profiles
      profiles = {
        global.enable = true;
        graphical.enable = true;
        laptop.enable = true;
      };

      ## modules
      hardware.nvidia.enable = true;
      nix.distributed-builds.enable = true;

      services.syncthing = {
        enable = true;
        user = "different";
        key = config.age.secrets."syncthing/potassium/key".path;
        cert = config.age.secrets."syncthing/potassium/cert".path;
      };

      system.autologin = {
        enable = true;
        user = "different";
      };
    };

    ### host specific

    hardware.nvidia.prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  }

{
  lib,
  config,
  inputs,
  ...
}:
lib.nix-files.mkHost {
  inherit config;

  hostName = "potassium";
  machineId = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
  diskConfiguration = ./_disk-configuration.nix;
  stateVersion = "24.05";

  content = {
    ### nix-files modules

    age.secrets = {
      "syncthing/potassium/key".file = inputs.self + /secrets/syncthing/potassium/key.age;
      "syncthing/potassium/cert".file = inputs.self + /secrets/syncthing/potassium/cert.age;
    };

    nix-files = {
      users.different.enable = true;

      profiles = {
        global.enable = true;
        graphical.enable = true;
        laptop.enable = true;
      };

      parts = {
        hardware = {
          nvidia.enable = true;
        };

        nix = {
          distributed-builds.enable = true;
        };

        services = {
          syncthing = {
            enable = true;
            user = "different";
            key = config.age.secrets."syncthing/potassium/key".path;
            cert = config.age.secrets."syncthing/potassium/cert".path;
          };
        };

        system = {
          autologin = {
            enable = true;
            user = "different";
          };
        };
      };
    };

    ### host specific

    hardware.nvidia.prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };
}

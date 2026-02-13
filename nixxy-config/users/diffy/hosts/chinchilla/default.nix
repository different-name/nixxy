{ lib, inputs, ... }:
let
  machineId = "7047404f861348299434d987ffcd50b2";

  ports = {
    minecraft = 25565;
    vintagestory = 42420;
  };

  portList = lib.attrValues ports;
in
{
  dyad = {
    users.diffy.enable = true;

    profiles = {
      minimal.enable = true;
      terminal.enable = true;
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };
  };

  nixos = {
    imports = [
      (inputs.import-tree ./_nixos)
    ];

    config = {
      networking = {
        hostName = "chinchilla";
        hostId = lib.substring 0 8 machineId;
      };

      environment.etc.machine-id.text = machineId;

      system.stateVersion = "24.05";

      networking.firewall = {
        allowedUDPPorts = portList;
        allowedTCPPorts = portList;
      };
    };
  };
}

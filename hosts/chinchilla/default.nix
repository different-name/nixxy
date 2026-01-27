{ lib, self, ... }:
let
  ports = {
    minecraft = 25565;
    vintagestory = 42420;
  };

  portList = lib.attrValues ports;
in
{
  imports = [
    self.nixosModules.dyad
  ];

  system.stateVersion = "24.05";

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

  networking.firewall = {
    allowedUDPPorts = portList;
    allowedTCPPorts = portList;
  };
}

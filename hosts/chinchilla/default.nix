{ self, ... }:
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

  networking.firewall.allowedUDPPorts = [ 25565 ];
  networking.firewall.allowedTCPPorts = [ 25565 ];
}

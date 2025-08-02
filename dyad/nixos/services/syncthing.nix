{ lib, config, ... }:
let
  syncthingPorts = [
    21027
    22000
  ];
in
{
  options.dyad.services.syncthing.enable = lib.mkEnableOption "syncthing config";

  config = lib.mkIf config.dyad.services.syncthing.enable {
    networking.firewall = {
      allowedUDPPorts = syncthingPorts;
      allowedTCPPorts = syncthingPorts;
    };
  };
}

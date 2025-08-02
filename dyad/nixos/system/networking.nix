{ lib, config, ... }:
{
  options.dyad.system.networking.enable = lib.mkEnableOption "networking config";

  config = lib.mkIf config.dyad.system.networking.enable {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
    };

    environment.perpetual.default.dirs = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}

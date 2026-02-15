{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "networking" ] {
  nixos = {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
    };

    environment.perpetual.default.dirs = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}

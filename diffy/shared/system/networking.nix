{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "networking" ] {
  nixos = {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
    };

    keep.safe.dirs = [ "/etc/NetworkManager/system-connections" ];
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "networking" ] {
  nixos = {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
    };

    keep.persist.dirs."/etc/NetworkManager/system-connections" = { };
  };
}

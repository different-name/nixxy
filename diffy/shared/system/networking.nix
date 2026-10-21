{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "networking" ] {
  nixos = {
    networking = {
      networkmanager.enable = true;
      enableIPv6 = false;
    };

    keep.safe.dirs = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];

    programs.keep.exclude = [
      "/etc/resolv.conf"
      "/etc/wpa_supplicant"
    ];
  };
}

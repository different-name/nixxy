{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "battery" ] {
  nixos = {
    services.upower = {
      enable = true;
      criticalPowerAction = "PowerOff";
    };

    keep.loose.dirs = [ "/var/lib/upower" ];
  };

  home-manager.services.poweralertd.enable = true;
}

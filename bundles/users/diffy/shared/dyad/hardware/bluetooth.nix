{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "bluetooth" ] {
  nixos = {
    hardware.bluetooth = {
      enable = true;
      # power the default bluetooth controller on boot
      powerOnBoot = true;
    };

    boot.kernelModules = [
      "btusb"
    ];

    services.blueman.enable = true;
  };
}

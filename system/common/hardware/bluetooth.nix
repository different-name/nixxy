{
  lib,
  config,
  ...
}: {
  options.nix-files.hardware.bluetooth.enable = lib.mkEnableOption "Bluetooth config";

  config = lib.mkIf config.nix-files.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      # power the default bluetooth controller on boot
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}

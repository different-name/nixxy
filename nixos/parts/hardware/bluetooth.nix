{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.hardware.bluetooth.enable = lib.mkEnableOption "bluetooth config";

  config = lib.mkIf config.nix-files.parts.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      # power the default bluetooth controller on boot
      powerOnBoot = true;
    };

    services.blueman.enable = true;
  };
}

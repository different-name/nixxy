{ lib, config, ... }:
{
  options.dyad.profiles.laptop.enable = lib.mkEnableOption "laptop profile";

  config = lib.mkIf config.dyad.profiles.laptop.enable {
    # backlight control
    hardware.brillo.enable = true;

    dyad.hardware.bluetooth.enable = true;
  };
}

{ lib, config, ... }:
{
  options.dyad.profiles.laptop.enable = lib.mkEnableOption "laptop profile";

  config = lib.mkIf config.dyad.profiles.laptop.enable {
    dyad.hardware.bluetooth.enable = true;

    hardware.brillo.enable = true; # backlight control
  };
}

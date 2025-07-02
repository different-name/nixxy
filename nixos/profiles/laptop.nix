{ lib, config, ... }:
{
  options.nix-files.profiles.laptop.enable = lib.mkEnableOption "laptop profile";

  config = lib.mkIf config.nix-files.profiles.laptop.enable {
    # backlight control
    hardware.brillo.enable = true;

    nix-files.parts.hardware.bluetooth.enable = true;
  };
}

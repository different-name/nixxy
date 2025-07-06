{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.hardware.ddcutil.enable = lib.mkEnableOption "ddcutil config";

  config = lib.mkIf config.dyad.hardware.ddcutil.enable {
    hardware.i2c.enable = true;

    environment.systemPackages = with pkgs; [ ddcutil ];
  };
}

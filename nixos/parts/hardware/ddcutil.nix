{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.parts.hardware.ddcutil.enable = lib.mkEnableOption "ddcutil config";

  config = lib.mkIf config.nix-files.parts.hardware.ddcutil.enable {
    hardware.i2c.enable = true;

    environment.systemPackages = with pkgs; [ddcutil];
  };
}

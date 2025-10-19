{
  lib,
  config,
  inputs',
  ...
}:
{
  options.dyad.desktop.hexecute.enable = lib.mkEnableOption "hexecute config";

  config = lib.mkIf config.dyad.desktop.hexecute.enable {
    home.packages = [
      inputs'.hexecute.packages.hexecute
    ];

    home.perpetual.default.dirs = [
      "$configHome/hexecute"
    ];
  };
}

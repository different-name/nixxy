{ lib, config, ... }:
{
  options.dyad.terminal.yazi.enable = lib.mkEnableOption "yazi config";

  config = lib.mkIf config.dyad.terminal.yazi.enable {
    programs.yazi.enable = true;

    home.perpetual.default.dirs = [
      "$stateHome/yazi"
    ];
  };
}

{ lib, config, ... }:
{
  options.dyad.terminal.yazi.enable = lib.mkEnableOption "yazi config";

  config = lib.mkIf config.dyad.terminal.yazi.enable {
    programs.yazi.enable = true;

    home.persistence-wrapper.dirs = [
      ".local/state/yazi"
    ];
  };
}

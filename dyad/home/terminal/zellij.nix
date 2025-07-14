{ lib, config, ... }:
{
  options.dyad.terminal.zellij.enable = lib.mkEnableOption "zellij config";

  config = lib.mkIf config.dyad.terminal.zellij.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}

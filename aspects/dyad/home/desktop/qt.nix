{ lib, config, ... }:
{
  options.dyad.desktop.qt.enable = lib.mkEnableOption "qt config";

  config = lib.mkIf config.dyad.desktop.qt.enable {
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}

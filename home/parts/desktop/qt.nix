{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.desktop.qt.enable = lib.mkEnableOption "qt config";

  config = lib.mkIf config.nix-files.parts.desktop.qt.enable {
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}

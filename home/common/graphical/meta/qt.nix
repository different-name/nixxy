{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.meta.qt.enable = lib.mkEnableOption "Qt config";

  config = lib.mkIf config.nix-files.graphical.meta.qt.enable {
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}

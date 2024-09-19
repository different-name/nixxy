{
  lib,
  config,
  ...
}: {
  options.nix-files.programs.qt.enable = lib.mkEnableOption "qt config";

  config = lib.mkIf config.nix-files.programs.qt.enable {
    qt = {
      enable = true;
      style = "kvantum";
      platformTheme = "qt5ct";
    };
  };
}

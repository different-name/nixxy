{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "qt" ] {
  nixos.qt = {
    enable = true;
    style = "kvantum";
    platformTheme = "qt5ct";
  };

  home-manager.qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
}

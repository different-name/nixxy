{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "qt" ] {
  nixos.qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  home-manager =
    { config, pkgs, ... }:
    let
      qtctSettings.Appearance = {
        style = "kvantum";
        icon_theme = config.gtk.iconTheme.name;
      };
    in
    {
      # style set through qtct, QT_STYLE_OVERRIDE breaks the org.kde.desktop qml style
      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.package = [
          pkgs.libsForQt5.qtstyleplugin-kvantum
          pkgs.qt6Packages.qtstyleplugin-kvantum
        ];
        qt5ctSettings = qtctSettings;
        qt6ctSettings = qtctSettings;
      };

      home.packages = [
        pkgs.kdePackages.qqc2-desktop-style
      ];
    };
}

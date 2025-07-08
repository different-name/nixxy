{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.applications.extra-packages.enable = lib.mkEnableOption "extra application packages";

  config = lib.mkIf config.dyad.applications.extra-packages.enable {
    dyad.system.persistence.installPkgsWithPersistence = {
      android-tools.dirs = [
        ".android"
      ];

      gimp-with-plugins.dirs = [
        ".config/GIMP"
        ".cache/gimp"
      ];

      protonvpn-gui.dirs = [
        ".config/Proton"
        ".cache/Proton"
      ];

      qbittorrent.dirs = [
        ".config/qBittorrent"
        ".local/share/qBittorrent"
        ".cache/qBittorrent"
      ];
    };

    home.packages = with pkgs; [
      qalculate-gtk
      qpwgraph
      scrcpy
    ];
  };
}

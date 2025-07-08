{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.applications.extra-packages.enable = lib.mkEnableOption "extra application packages";

  config = lib.mkIf config.dyad.applications.extra-packages.enable {
    home.packages = with pkgs; [
      android-tools
      gimp-with-plugins
      protonvpn-gui
      qalculate-gtk
      qbittorrent
      scrcpy
      qpwgraph
    ];

    dyad.system.persistence = {
      dirs = [
        # android-tools
        ".android"

        # bambu-studio
        ".config/BambuStudio"
        ".local/share/bambu-studio"
        ".cache/bambu-studio"

        # gimp
        ".config/GIMP"
        ".cache/gimp"

        # qbittorrent
        ".config/qBittorrent"
        ".local/share/qBittorrent"
        ".cache/qBittorrent"

        # protonvpn-gui
        ".config/Proton"
        ".cache/Proton"

        ### system level

        # thunar
        ".config/Thunar"
        ".local/share/gvfs-metadata" # gnome virtual file system data / cache
      ];

      files = [
        # thunar
        ".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
      ];
    };
  };
}

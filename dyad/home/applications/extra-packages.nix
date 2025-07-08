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
      # keep-sorted start block=yes newline_separated=yes
      android-tools.dirs = [
        ".android"
      ];

      gimp-with-plugins.dirs = [
        # keep-sorted start
        ".cache/gimp"
        ".config/GIMP"
        # keep-sorted end
      ];

      protonvpn-gui.dirs = [
        # keep-sorted start
        ".cache/Proton"
        ".config/Proton"
        # keep-sorted end
      ];

      qbittorrent.dirs = [
        # keep-sorted start
        ".cache/qBittorrent"
        ".config/qBittorrent"
        ".local/share/qBittorrent"
        # keep-sorted end
      ];
      # keep-sorted end
    };

    home.packages = with pkgs; [
      # keep-sorted start
      qalculate-gtk
      qpwgraph
      scrcpy
      # keep-sorted end
    ];
  };
}

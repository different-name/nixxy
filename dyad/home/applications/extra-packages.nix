{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.applications.extra-packages.enable = lib.mkEnableOption "extra application packages";

  config = lib.mkIf config.dyad.applications.extra-packages.enable {
    home.perpetual.default.packages = {
      # keep-sorted start block=yes newline_separated=yes
      android-tools.dirs = [
        ".android"
      ];

      gimp-with-plugins.dirs = [
        # keep-sorted start
        "$cacheHome/gimp"
        "$configHome/GIMP"
        # keep-sorted end
      ];

      protonvpn-gui.dirs = [
        # keep-sorted start
        "$cacheHome/Proton"
        "$configHome/Proton"
        # keep-sorted end
      ];

      qbittorrent.dirs = [
        # keep-sorted start
        "$cacheHome/qBittorrent"
        "$configHome/qBittorrent"
        "$dataHome/qBittorrent"
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

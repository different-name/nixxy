{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.applications.applications-pkgs.enable =
    lib.mkEnableOption "extra application packages";

  config = lib.mkIf config.dyad.applications.applications-pkgs.enable {
    home.perpetual.default.packages = {
      # keep-sorted start block=yes newline_separated=yes
      android-tools.dirs = [
        ".android"
      ];

      emote.dirs = [
        "$dataHome/Emote"
      ];

      ente-desktop.dirs = [
        "$configHome/ente"
      ];

      gimp3-with-plugins.dirs = [
        "$cacheHome/gimp"
        "$configHome/GIMP"
      ];

      nrfconnect.dirs = [
        "$configHome/nrfconnect"
        ".nrfconnect-apps"
      ];

      polychromatic.dirs = [
        "$configHome/polychromatic"
        "$cacheHome/polychromatic"
      ];

      protonvpn-gui.dirs = [
        "$cacheHome/Proton"
        "$configHome/Proton"
      ];

      qbittorrent.dirs = [
        # keep-sorted start
        "$cacheHome/qBittorrent"
        "$configHome/qBittorrent"
        "$dataHome/qBittorrent"
        # keep-sorted end
      ];

      signal-desktop.dirs = [
        "$configHome/Signal"
      ];
      # keep-sorted end
    };

    home.packages = with pkgs; [
      # keep-sorted start
      pavucontrol
      qalculate-gtk
      qpwgraph
      scrcpy
      # keep-sorted end
    ];
  };
}

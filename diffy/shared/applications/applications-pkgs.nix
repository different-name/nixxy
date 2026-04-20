{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "extraPackages" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.perpetual.default.packages = {
        # keep-sorted start block=yes newline_separated=yes
        android-tools.dirs = [
          ".android"
        ];

        blender.dirs = [
          "$cacheHome/blender"
          "$configHome/blender"
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

        notesnook.dirs = [
          "$configHome/Notesnook"
        ];

        nrfconnect.dirs = [
          "$configHome/nrfconnect"
          ".nrfconnect-apps"
        ];

        proton-pass.dirs = [
          "$configHome/Proton Pass"
        ];

        proton-vpn.dirs = [
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

        spotify.dirs = [
          "$configHome/spotify"
          "$cacheHome/spotify"
        ];
        # keep-sorted end
      };

      home.packages = with pkgs; [
        # keep-sorted start
        pavucontrol
        qalculate-gtk
        scrcpy
        # keep-sorted end
      ];
    };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    keep.persist.packages = {
      # keep-sorted start block=yes newline_separated=yes
      android-tools.dirs.".android" = { };

      emote.xdg.data.dirs."Emote" = { };

      ente-desktop.xdg.config.dirs."ente" = { };

      gimp3-with-plugins = {
        xdg.cache.dirs."gimp" = { };
        xdg.config.dirs."GIMP" = { };
      };

      nrfconnect = {
        dirs.".nrfconnect-apps" = { };
        xdg.config.dirs."nrfconnect" = { };
      };

      proton-pass.xdg.config.dirs."Proton Pass" = { };

      proton-vpn = {
        xdg.cache.dirs."Proton" = { };
        xdg.config.dirs."Proton" = { };
      };

      qbittorrent = {
        xdg.cache.dirs."qBittorrent" = { };
        xdg.config.dirs."qBittorrent" = { };
        xdg.data.dirs."qBittorrent" = { };
      };
      # keep-sorted end
    };

    keep.persist = {
      xdg.config.dirs."hearth" = { };
      xdg.state.dirs."hearth" = { };
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

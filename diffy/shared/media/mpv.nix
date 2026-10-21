{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "mpv" ] {
  home-manager = {
    programs.mpv = {
      enable = true;
      config = {
        # fix for discord stream audio capture
        ao = "pulse";
      };
    };

    keep.persist.xdg.cache.dirs."mpv" = { };
  };
}

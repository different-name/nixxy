{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "vrcx" ] {
  home-manager = { pkgs, ... }: {
    home.packages = [ pkgs.vrcx ];

    xdg.configFile."VRCX/custom.css".source = ./custom.css;

    keep.persist = {
      xdg.cache.dirs."VRCX" = { };
      xdg.config.dirs."VRCX" = { };
    };
  };
}

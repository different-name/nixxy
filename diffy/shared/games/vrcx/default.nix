{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "vrcx" ] {
  home-manager = { pkgs, ... }: {
    home.packages = [ pkgs.vrcx ];

    xdg.configFile."VRCX/custom.css".source = ./custom.css;

    keep.safe = {
      cacheDirs = [ "VRCX" ];
      configDirs = [ "VRCX" ];
    };
  };
}

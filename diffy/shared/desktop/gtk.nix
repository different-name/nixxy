{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "gtk" ] {
  home-manager = {
    gtk = {
      enable = true;
      font = {
        name = "Inter";
        size = 11;
      };
    };
    dconf.settings."org/gnome/desktop/interface".font-name = "Inter 11";
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "gtk" ] {
  home-manager = {
    gtk = {
      enable = true;
      font = {
        name = "Onest";
        size = 11;
      };
    };
    dconf.settings."org/gnome/desktop/interface".font-name = "Onest 11";

    programs.keep.exclude = [
      ".config/dconf"
      ".local/share/recently-used.xbel"
    ];
  };
}

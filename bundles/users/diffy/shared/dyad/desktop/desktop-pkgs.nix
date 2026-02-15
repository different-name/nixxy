{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "desktop-pkgs" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.libnotify
        pkgs.wl-clipboard
      ];
    };
}

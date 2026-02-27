{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "extraPackages" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.libnotify
        pkgs.wl-clipboard
      ];
    };
}

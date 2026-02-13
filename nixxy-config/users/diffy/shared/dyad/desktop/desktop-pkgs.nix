{ lib, config, ... }:
{
  options.dyad.desktop.desktop-pkgs.enable = lib.mkEnableOption "extra desktop packages";

  config = lib.mkIf config.dyad.desktop.desktop-pkgs.enable {
    hm =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.libnotify
          pkgs.wl-clipboard
        ];
      };
  };
}

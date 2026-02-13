{ lib, config, ... }:
{
  options.dyad.desktop.desktop-pkgs.enable = lib.mkEnableOption "extra desktop packages";

  config = lib.mkIf config.dyad.desktop.desktop-pkgs.enable {
    home-manager =
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.libnotify
          pkgs.wl-clipboard
        ];
      };
  };
}

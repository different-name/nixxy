{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.desktop.desktop-pkgs.enable = lib.mkEnableOption "extra desktop packages";

  config = lib.mkIf config.dyad.desktop.desktop-pkgs.enable {
    home.packages = [
      pkgs.libnotify
      pkgs.wl-clipboard
    ];
  };
}

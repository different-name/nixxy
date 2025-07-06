{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.desktop.extra-packages.enable = lib.mkEnableOption "extra desktop packages";

  config = lib.mkIf config.dyad.desktop.extra-packages.enable {
    home.packages = with pkgs; [
      pavucontrol
      wl-clipboard
      libnotify
    ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.desktop.desktop-pkgs.enable = lib.mkEnableOption "extra desktop packages";

  config = lib.mkIf config.dyad.desktop.desktop-pkgs.enable {
    home.packages = with pkgs; [
      # keep-sorted start
      libnotify
      pavucontrol
      wl-clipboard
      # keep-sorted end
    ];
  };
}

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
      # keep-sorted start
      libnotify
      pavucontrol
      wl-clipboard
      # keep-sorted end
    ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.desktop.niri.enable = lib.mkEnableOption "niri config";

  config = lib.mkIf config.dyad.desktop.niri.enable {
    programs = {
      niri.enable = true;

      uwsm.waylandCompositors.niri = {
        binPath = lib.getExe config.programs.niri.package;
        comment = "Niri session managed by uwsm";
        prettyName = "Niri";
      };
    };

    environment.systemPackages = [
      pkgs.xwayland-satellite
    ];
  };
}

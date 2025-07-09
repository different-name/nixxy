{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
{
  options.dyad.media.goxlr-utility.enable = lib.mkEnableOption "goxlr-utility config";

  config = lib.mkIf config.dyad.media.goxlr-utility.enable {
    xdg.dataFile."goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
      source = ./procaster.goxlrMicProfile;
    };

    xdg.autostart.entries = [
      (
        (pkgs.makeDesktopItem {
          name = "goxlr-daemon";
          destination = "/";
          desktopName = "GoXLR Daemon";
          noDisplay = true;
          exec = lib.getExe' osConfig.services.goxlr-utility.package "goxlr-daemon";
        })
        + /goxlr-daemon.desktop
      )
    ];

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$configHome/goxlr-utility"
      "$dataHome/goxlr-utility"
      # keep-sorted end
    ];
  };
}

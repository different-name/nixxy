{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
{
  options.nix-files.parts.media.goxlr-utility.enable = lib.mkEnableOption "goxlr-utility config";

  config = lib.mkIf config.nix-files.parts.media.goxlr-utility.enable {
    home.file.".local/share/goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
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

    home.persistence."/persist".directories = [
      ".config/goxlr-utility"
      ".local/share/goxlr-utility"
    ];
  };
}

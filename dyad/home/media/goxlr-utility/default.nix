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

    xdg.autostart.entries = lib.singleton (
      (pkgs.makeDesktopItem {
        name = "goxlr-daemon";
        destination = "/";
        desktopName = "GoXLR Daemon";
        noDisplay = true;
        exec = lib.getExe' osConfig.services.goxlr-utility.package "goxlr-daemon";
      })
      + /goxlr-daemon.desktop
    );

    wayland.windowManager.hyprland.settings.bind =
      let
        toggleMute = pkgs.writeShellApplication {
          name = "goxlr-utility-tg-mute";
          runtimeInputs = with pkgs; [
            jq
            goxlr-utility
          ];
          text = builtins.readFile ./toggle-mute.sh;
        };
      in
      [
        "$mod, Z, exec, ${lib.getExe toggleMute}"
      ];

    home.perpetual.default.dirs = [
      # keep-sorted start
      "$configHome/goxlr-utility"
      "$dataHome/goxlr-utility"
      # keep-sorted end
    ];
  };
}

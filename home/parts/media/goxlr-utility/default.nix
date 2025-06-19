{
  lib,
  config,
  osConfig,
  ...
}:
{
  options.nix-files.parts.media.goxlr-utility.enable = lib.mkEnableOption "goxlr-utility config";

  config = lib.mkIf config.nix-files.parts.media.goxlr-utility.enable {
    home.file.".local/share/goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
      source = ./procaster.goxlrMicProfile;
    };

    wayland.windowManager.hyprland.settings.exec-once =
      let
        uwsmCmd = lib.optionalString osConfig.programs.uwsm.enable "uwsm app -- ";
        uwsmSingleApp = cmd: "pgrep ${cmd} || ${uwsmCmd + cmd}";
      in
      map uwsmSingleApp [
        "goxlr-daemon"
      ];

    home.persistence."/persist".directories = [
      ".config/goxlr-utility"
      ".local/share/goxlr-utility"
    ];
  };
}

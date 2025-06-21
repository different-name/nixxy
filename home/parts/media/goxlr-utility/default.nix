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

    xdg.autostart.entries = [
      "${osConfig.services.goxlr-utility.package}/share/applications/goxlr-utility.desktop"
    ];

    home.persistence."/persist".directories = [
      ".config/goxlr-utility"
      ".local/share/goxlr-utility"
    ];
  };
}

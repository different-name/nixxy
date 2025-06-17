{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.media.goxlr-utility.enable = lib.mkEnableOption "GoXLR-utility config";

  config = lib.mkIf config.nix-files.parts.media.goxlr-utility.enable {
    home.file.".local/share/goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
      source = ./procaster.goxlrMicProfile;
    };

    home.persistence."/persist".directories = [
      ".config/goxlr-utility"
      ".local/share/goxlr-utility"
    ];
  };
}

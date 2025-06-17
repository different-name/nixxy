{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.media.mpv.enable = lib.mkEnableOption "mpv config";

  config = lib.mkIf config.nix-files.parts.media.mpv.enable {
    programs.mpv.enable = true;

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".cache/mpv"
      ];
    };
  };
}

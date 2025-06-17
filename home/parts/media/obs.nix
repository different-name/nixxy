{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.media.obs.enable = lib.mkEnableOption "OBS config";

  config = lib.mkIf config.nix-files.parts.media.obs.enable {
    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".config/obs-studio"
      ];
    };
  };
}

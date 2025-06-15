{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.media.obs.enable = lib.mkEnableOption "OBS config";

  config = lib.mkIf config.nix-files.graphical.media.obs.enable {
    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/obs-studio"
      ];
    };
  };
}

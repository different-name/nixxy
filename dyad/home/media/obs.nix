{ lib, config, ... }:
{
  options.dyad.media.obs.enable = lib.mkEnableOption "obs config";

  config = lib.mkIf config.dyad.media.obs.enable {
    dyad.system.persistence = {
      directories = [
        ".config/obs-studio"
      ];
    };
  };
}

{ lib, config, ... }:
{
  options.nix-files.parts.media.obs.enable = lib.mkEnableOption "obs config";

  config = lib.mkIf config.nix-files.parts.media.obs.enable {
    nix-files.parts.system.persistence = {
      directories = [
        ".config/obs-studio"
      ];
    };
  };
}

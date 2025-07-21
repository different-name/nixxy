{ lib, config, ... }:
{
  options.dyad.programs.obs-studio.enable = lib.mkEnableOption "obs-studio config";

  config = lib.mkIf config.dyad.programs.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    home-manager.sharedModules = lib.singleton {
      programs.obs-studio.enable = true;

      home.perpetual.default.dirs = [
        "$configHome/obs-studio"
      ];
    };
  };
}

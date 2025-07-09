{ lib, config, ... }:
{
  options.dyad.programs.obs.enable = lib.mkEnableOption "obs config";

  config = lib.mkIf config.dyad.programs.obs.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    home-manager.sharedModules = lib.singleton {
      home.perpetual.default.dirs = [
        "$configHome/obs-studio"
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.programs.obs-studio.enable = lib.mkEnableOption "obs-studio config";

  config = lib.mkIf config.dyad.programs.obs-studio.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    home-manager.sharedModules = lib.singleton {
      programs.obs-studio = {
        enable = true;
        plugins = [
          pkgs.obs-studio-plugins.obs-move-transition
        ];
      };

      home.perpetual.default.dirs = [
        "$configHome/obs-studio"
        "$cacheHome/obs-studio"
      ];
    };
  };
}

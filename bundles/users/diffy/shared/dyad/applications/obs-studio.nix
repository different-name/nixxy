{ lib, config, ... }:
{
  options.dyad.applications.obs-studio.enable = lib.mkEnableOption "obs-studio config";

  config = lib.mkIf config.dyad.applications.obs-studio.enable {
    nixos.programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    home-manager =
      { pkgs, ... }:
      {
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

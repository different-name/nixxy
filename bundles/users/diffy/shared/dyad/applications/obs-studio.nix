{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "obs-studio" ] {
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
}

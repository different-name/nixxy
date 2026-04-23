{
  bundleLib,
  inputs,
  ...
}:
let
  mkWrappedObs =
    pkgs:
    inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.obs-studio;
      env.__NV_DISABLE_EXPLICIT_SYNC = 1;
    };
in
bundleLib.mkEnableModule [ "dyad" "applications" "obs-studio" ] {
  nixos =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        package = mkWrappedObs pkgs;
        enableVirtualCamera = true;
      };
    };

  home-manager =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        package = mkWrappedObs pkgs;
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

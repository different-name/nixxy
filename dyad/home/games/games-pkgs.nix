{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.games.games-pkgs.enable = lib.mkEnableOption "extra games packages";

  config = lib.mkIf config.dyad.games.games-pkgs.enable {
    home.perpetual.default = {
      packages = {
        # keep-sorted start block=yes newline_separated=yes
        bottles = {
          package = pkgs.bottles.override {
            removeWarningPopup = true;
          };
          dirs = [
            "$dataHome/bottles"
          ];
        };

        lutris.dirs = [
          "$cacheHome/lutris"
          "$dataHome/lutris"
        ];

        nexusmods-app.dirs = [
          "$stateHome/NexusMods.App"
        ];

        osu-lazer-bin.dirs = [
          "$dataHome/osu"
        ];

        prismlauncher = {
          package = pkgs.prismlauncher.override {
            jdks = [
              pkgs.temurin-bin
            ];
          };
          dirs = [
            "$dataHome/PrismLauncher"
          ];
        };

        r2modman.dirs = [
          "$configHome/r2modman"
          "$configHome/r2modmanPlus-local"
        ];
        # keep-sorted end
      };

      dirs = [
        # keep-sorted start
        "$cacheHome/mesa_shader_cache_db" # shader cache
        "$dataHome/umu" # proton runtime
        "$dataHome/vulkan/" # shader cache files?
        ".nv" # OpenGL cache
        # keep-sorted end
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/nxm" = "com.nexusmods.app.desktop";
    };
  };
}

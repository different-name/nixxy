{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.games.extra-packages.enable = lib.mkEnableOption "extra games packages";

  config = lib.mkIf config.dyad.games.extra-packages.enable {
    dyad.system.persistence = {
      installPkgsWithPersistence = {
        lutris.dirs = [
          ".local/share/lutris"
          ".cache/lutris"
        ];

        osu-lazer-bin.dirs = [
          ".local/share/osu"
        ];

        prismlauncher = {
          package = pkgs.prismlauncher.override {
            jdks = [
              pkgs.temurin-bin
            ];
          };
          dirs = [
            ".local/share/PrismLauncher"
          ];
        };
      };

      dirs = [
        ".nv" # OpenGL cache
        ".local/share/vulkan/" # shader cache files?
        ".cache/mesa_shader_cache_db" # shader cache
        ".local/share/umu" # proton runtime
      ];
    };
  };
}

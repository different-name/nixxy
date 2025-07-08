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
        # keep-sorted start block=yes newline_separated=yes
        lutris.dirs = [
          # keep-sorted start
          ".cache/lutris"
          ".local/share/lutris"
          # keep-sorted end
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
        # keep-sorted end
      };

      dirs = [
        # keep-sorted start
        ".cache/mesa_shader_cache_db" # shader cache
        ".local/share/umu" # proton runtime
        ".local/share/vulkan/" # shader cache files?
        ".nv" # OpenGL cache
        # keep-sorted end
      ];
    };
  };
}

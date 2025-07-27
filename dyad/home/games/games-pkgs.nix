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
        lutris.dirs = [
          # keep-sorted start
          "$cacheHome/lutris"
          "$dataHome/lutris"
          # keep-sorted end
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
  };
}

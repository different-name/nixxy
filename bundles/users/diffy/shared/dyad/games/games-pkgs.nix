{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "games-pkgs" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.perpetual.default = {
        packages = {
          # keep-sorted start block=yes newline_separated=yes
          osu-lazer-bin.dirs = [
            "$dataHome/osu"
          ];

          prismlauncher = {
            package = pkgs.prismlauncher.override {
              jdks = [
                pkgs.temurin-bin
                pkgs.javaPackages.compiler.temurin-bin.jre-17
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

          vintagestory.dirs = [
            "$configHome/VintagestoryData"
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

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    home.perpetual.default = {
      packages = {
        # keep-sorted start block=yes newline_separated=yes
        osu-lazer-bin.dirs = [
          "$dataHome/osu"
        ];

        prismlauncher = {
          package = pkgs.prismlauncher.override {
            jdks = with pkgs; [
              temurin-bin
              temurin-bin-17
              temurin-bin-25
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
        "$cacheHome/mesa_shader_cache" # shader cache
        "$cacheHome/qtshadercache-x86_64-little_endian-lp64" # qt shader cache
        "$cacheHome/radv_builtin_shaders" # radv shader cache
        "$dataHome/umu" # proton runtime
        "$dataHome/vulkan" # steam fossilize and overlay layers
        # keep-sorted end
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/nxm" = "com.nexusmods.app.desktop";
    };
  };
}

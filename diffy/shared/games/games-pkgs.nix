{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    keep.persist = {
      packages = {
        # keep-sorted start block=yes newline_separated=yes
        osu-lazer-bin.xdg.data.dirs."osu" = { };

        prismlauncher = {
          package = pkgs.prismlauncher.override {
            jdks = with pkgs; [
              temurin-bin
              temurin-bin-17
              temurin-bin-25
            ];
          };
          xdg.data.dirs."PrismLauncher" = { };
        };

        r2modman.xdg.config.dirs = {
          "r2modman" = { };
          "r2modmanPlus-local" = { };
        };
        # keep-sorted end
      };

      xdg.cache.dirs = {
        # keep-sorted start
        "mesa_shader_cache" = { }; # shader cache
        "qtshadercache-x86_64-little_endian-lp64" = { }; # qt shader cache
        "radv_builtin_shaders" = { }; # radv shader cache
        # keep-sorted end
      };

      xdg.data.dirs = {
        "umu" = { }; # proton runtime
        "vulkan" = { }; # steam fossilize and overlay layers
      };
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/nxm" = "com.nexusmods.app.desktop";
    };
  };
}

{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    imports = lib.attrValues {
      # keep-sorted start block=yes newline_separated=yes
      osu = {
        home.packages = [ pkgs.osu-lazer-bin ];
        keep.safe.dataDirs = [ "osu" ];
      };

      prismlauncher = {
        home.packages = [
          (pkgs.prismlauncher.override {
            jdks = with pkgs; [
              temurin-bin
              temurin-bin-17
              temurin-bin-25
            ];
          })
        ];
        keep.safe.dataDirs = [ "PrismLauncher" ];
      };

      r2modman = {
        home.packages = [ pkgs.r2modman ];
        keep.safe.configDirs = [
          "r2modman"
          "r2modmanPlus-local"
        ];
      };
      # keep-sorted end
    };

    keep.safe = {
      cacheDirs = [
        # keep-sorted start
        "mesa_shader_cache" # shader cache
        "qtshadercache-x86_64-little_endian-lp64" # qt shader cache
        "radv_builtin_shaders" # radv shader cache
        # keep-sorted end
      ];

      dataDirs = [
        "umu" # proton runtime
        "vulkan" # steam fossilize and overlay layers
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/nxm" = "com.nexusmods.app.desktop";
    };
  };
}

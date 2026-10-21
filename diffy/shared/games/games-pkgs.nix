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
  };
}

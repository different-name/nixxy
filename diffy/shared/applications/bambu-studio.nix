{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "bambu-studio" ] {
  home-manager = { pkgs, osConfig, ... }: {
    home.perpetual.default.packages.bambu-studio = {
      package =
        (pkgs.bambu-studio.override {
          # blank viewport on nvidia proprietary gl, routes through mesa + zink
          withNvidiaGLWorkaround = lib.elem "nvidia" osConfig.services.xserver.videoDrivers;
          # cuda opencv's cmake config demands nvcc, which isn't in bambu's build env
          opencv = pkgs.opencv.override { enableCuda = false; };
        }).overrideAttrs
          {
            # libslic3r's template heavy units eat gigabytes each, one per core swaps the machine to death
            ninjaFlags = [ "-j6" ];
          };

      dirs = [
        # keep-sorted start
        "$cacheHome/bambu-studio"
        "$configHome/BambuStudio"
        "$dataHome/bambu-studio"
        # keep-sorted end
      ];
    };
  };
}

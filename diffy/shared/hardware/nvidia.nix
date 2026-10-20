{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "nvidia" ] {
  nixos = {
    # load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = true;

      nvidiaSettings = false;
    };

    # per package, global cudaSupport forces source builds of anything with optional cuda
    nixpkgs.overlays = lib.singleton (
      _final: prev:
      let
        # own instance so deps get cuda too and match cache.nixos-cuda.org
        pkgsCuda = import prev.path {
          inherit (prev.stdenv.hostPlatform) system;
          config = {
            allowUnfree = true;
            cudaSupport = true;
          };
        };
      in
      {
        # cycles gpu rendering
        inherit (pkgsCuda) blender;
        # gpu stats
        btop = prev.btop.override { cudaSupport = true; };
        # nvenc
        obs-studio = prev.obs-studio.override { cudaSupport = true; };
        # nvenc
        wivrn = prev.wivrn.override { cudaSupport = true; };
      }
    );
  };

  home-manager.home.perpetual.default.dirs = [
    "$cacheHome/nvidia"
  ];
}

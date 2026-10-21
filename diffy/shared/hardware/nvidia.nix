{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "nvidia" ] {
  nixos = { config, ... }: {
    # load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # patchelf 0.19.2 maps .dynamic read-only when the rpath is set after the interpreter, https://github.com/NixOS/nixpkgs/issues/576412
      package = config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs (old: {
        postFixup = (old.postFixup or "") + ''
          for orig in $bin/origBin/*; do
            prog=$bin/bin/$(basename "$orig")
            rpath=$(patchelf --print-rpath "$prog")
            install -m755 "$orig" "$prog"
            patchelf --set-rpath "$rpath" "$prog"
            patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$prog"
          done
        '';
      });

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

  home-manager.keep.safe.cacheDirs = [ "nvidia" ];
}

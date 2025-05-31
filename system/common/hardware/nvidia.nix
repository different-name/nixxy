{
  lib,
  config,
  ...
}: {
  options.nix-files.hardware.nvidia.enable = lib.mkEnableOption "Nvidia config";

  config = lib.mkIf config.nix-files.hardware.nvidia.enable {
    # load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = false;

      nvidiaSettings = false;

      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "555.58.02";
      #   sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      #   sha256_aarch64 = lib.fakeSha256;
      #   openSha256 = lib.fakeSha256;
      #   settingsSha256 = lib.fakeSha256;
      #   persistencedSha256 = lib.fakeSha256;
      # };
    };

    nixpkgs.overlays = [
      # fails to build without CUDA_TOOLKIT_ROOT_DIR
      (final: prev: {
        rpcs3 = prev.rpcs3.overrideAttrs (old: {
          cmakeFlags =
            old.cmakeFlags
            ++ [
              "-DCUDA_TOOLKIT_ROOT_DIR=${prev.cudaPackages.cudatoolkit}"
            ];
        });
      })
    ];

    nixpkgs.config.cudaSupport = true;
  };
}

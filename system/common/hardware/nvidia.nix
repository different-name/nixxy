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
      #   version = "560.35.03";
      #   sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
      #   sha256_aarch64 = lib.fakeSha256;
      #   openSha256 = lib.fakeSha256;
      #   settingsSha256 = lib.fakeSha256;
      #   persistencedSha256 = lib.fakeSha256;
      # };
    };
  };
}

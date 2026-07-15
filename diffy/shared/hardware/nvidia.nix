{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "nvidia" ] {
  nixos = { config, ... }: {
    # load nvidia driver for xorg and wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      open = true;

      nvidiaSettings = false;

      # TODO remove after fixed, 595 nvenc faults/hangs the encoder in wivrn
      package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    };

    nixpkgs.config.cudaSupport = true;
  };

  home-manager.home.perpetual.default.dirs = [
    "$cacheHome/nvidia"
  ];
}

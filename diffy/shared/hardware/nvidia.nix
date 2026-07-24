{ bundleLib, ... }:
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

    nixpkgs.config.cudaSupport = true;
  };

  home-manager.home.perpetual.default.dirs = [
    "$cacheHome/nvidia"
  ];
}

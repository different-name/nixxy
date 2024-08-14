{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    ../../global
    ../../desktop

    ../../extra/users/different.nix

    ../../extra/hardware/nvidia.nix

    ../../extra/programs/alvr.nix
    ../../extra/programs/goxlr-utility.nix

    (import ../../extra/services/autologin.nix "different")
    ../../extra/services/keyd.nix
    ../../extra/services/tailscale.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "sodium";
    hostId = "9471422d";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users."different" = import ../../../home/users/different/hosts/sodium.nix;
  };

  # nh default flake
  programs.nh.flake = "/home/different/nix-files";

  nix-files.xDisplayScale = {
    enable = true;
    value = "1.5";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

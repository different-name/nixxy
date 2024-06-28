{
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    ../../system

    ../../system/hardware/nvidia.nix

    ../../system/programs/goxlr-utility.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "sodium";
    hostId = "9471422d";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.different = import ../../home/different/hosts/sodium;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

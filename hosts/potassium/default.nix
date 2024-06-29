{
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    ../../system

    ../../system/hardware/nvidia.nix

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  hardware.nvidia.prime = {
    nvidiaBusId = "";
    intelBusId = "";
  };

  networking = {
    hostName = "potassium";
    hostId = "9471422d";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.different = import ../../home/different/hosts/potassium;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

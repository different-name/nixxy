{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    ../../users/different.nix

    ../../common/global
    ../../common/desktop

    ../../common/extra/hardware/backlight.nix
    ../../common/extra/hardware/bluetooth.nix
    ../../common/extra/hardware/nvidia.nix

    (import ../../common/extra/services/autologin.nix "different")

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "potassium";
    hostId = "ea3a24c5";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users."different" = import "${self}/home/users/different/hosts/potassium.nix";
  };

  # nh default flake
  programs.nh.flake = "/home/different/nix-files";

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

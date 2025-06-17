{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.dell-xps-15-9500-nvidia
  ];

  nix-files.host = "potassium";
}

# this file is imported explicitly by configurations.nix at the flake root
# it is the only module file not imported (directly or indirectly) via import-tree
# this file is reserved for non-configurable imports, such as modules from nixos-hardware
{ inputs, ... }:
{
  imports = [
    ./_hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];
}

{outputs, ...}: {
  imports = [
    outputs.nixosModules.nix-files

    ./core
    ./hardware
    ./nix
    ./programs
    ./services
  ];
}

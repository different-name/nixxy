{self, ...}: {
  imports = [
    self.nixosModules.nix-files

    ./core
    ./hardware
    ./nix
    ./programs
    ./services
  ];
}

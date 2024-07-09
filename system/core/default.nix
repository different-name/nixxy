{lib, ...}: {
  imports = [
    ./boot.nix
    ./disko.nix
    ./locale.nix
    ./persistence.nix
    ./security.nix
    ./users.nix
    ./zfs.nix
  ];
}

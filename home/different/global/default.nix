{inputs, ...}: {
  imports = [
    ../../.

    ./programs
    ./services
    ./terminal
    ./persistence.nix

    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home = {
    username = "different";
    homeDirectory = "/home/different";
  };
}

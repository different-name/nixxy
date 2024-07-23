{
  inputs,
  pkgs,
  osConfig,
  self,
  ...
}: let
  inherit (osConfig.nix-files) user;
in {
  imports = [
    ./programs
    ./services
    ./terminal
    ./persistence.nix

    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  # home-manager config

  nixpkgs.config.allowUnfree = true;
  # let home-manager manage itself when in standalone mode
  programs.home-manager.enable = true;
  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };
}

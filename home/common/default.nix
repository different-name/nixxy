{
  imports = [
    ./graphical
    ./services
    ./terminal
    ./catppuccin.nix
    ./persistence.nix
  ];

  nixpkgs.config.allowUnfree = true;

  # let home-manager manage itself when in standalone mode
  programs.home-manager.enable = true;

  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

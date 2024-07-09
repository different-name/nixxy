{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  nixpkgs.config.allowUnfree = true;

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;
  # reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

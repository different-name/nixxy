{inputs, ...}: {
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager

    ./binds.nix
    ./rules.nix
    ./settings.nix
  ];

  programs.plasma = {
    enable = true;

    # reset all undeclared settings to default on login
    # unpersisted configs are reset at boot due to the ephemeral setup regardless
    overrideConfig = true;
  };
}

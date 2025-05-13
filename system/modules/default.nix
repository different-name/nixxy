{
  flake.nixosModules = {
    ephemeral-tools = import ./ephemeral-tools.nix;
  };
}

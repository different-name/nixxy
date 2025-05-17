{
  flake.nixosModules = {
    ephemeral-tools = import ./ephemeral-tools.nix;
    wireplumber-connectPorts = import ./wireplumber-connectPorts;
  };
}

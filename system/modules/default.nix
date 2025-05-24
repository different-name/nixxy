{
  flake.nixosModules = {
    ephemeral-tools = import ./ephemeral-tools;
    wireplumber-connectPorts = import ./wireplumber-connectPorts;
  };
}

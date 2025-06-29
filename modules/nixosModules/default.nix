{
  flake.nixosModules = {
    ephemeral-tools = import ./ephemeral-tools;
    wireplumber-scripts = import ./wireplumber-scripts;
  };
}

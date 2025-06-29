{
  flake.nixosModules = {
    ephemeralTools = import ./ephemeral-tools;
    wireplumberScripts = import ./wireplumber-scripts;
  };
}

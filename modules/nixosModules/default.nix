{
  flake.nixosModules = {
    ephemeral-tools = import ./ephemeral-tools;
    steam-launch-options = import ./steam-launch-options;
    wireplumber-scripts = import ./wireplumber-scripts;
  };
}

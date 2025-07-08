{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  options.dyad.system.agenix.enable = lib.mkEnableOption "agenix config";

  config = lib.mkIf config.dyad.system.agenix.enable {
    age.identityPaths = [
      "/persist/home/different/.ssh/id_ed25519"
    ];

    home.packages = [
      inputs'.agenix.packages.agenix
    ];
  };
}

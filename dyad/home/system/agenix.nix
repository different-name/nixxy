{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
let
  inherit (config.home) persistence;
  inherit (persistence.default) persistentStoragePath;
  persistEnabled = lib.hasAttr "default" persistence && persistence.default.enable;
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
  ];

  options.dyad.system.agenix.enable = lib.mkEnableOption "agenix config";

  config = lib.mkIf config.dyad.system.agenix.enable {
    age.identityPaths = lib.mkIf persistEnabled [
      "${persistentStoragePath}${config.home.homeDirectory}/.ssh/id_ed25519"
    ];

    home.packages = [
      inputs'.agenix.packages.agenix
    ];
  };
}

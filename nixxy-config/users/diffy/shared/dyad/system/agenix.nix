{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
{
  options.dyad.system.agenix.enable = lib.mkEnableOption "agenix config";

  config = lib.mkIf config.dyad.system.agenix.enable {
    nixos = {
      imports = [
        inputs.agenix.nixosModules.default
      ];

      config = {
        # access to the hostkey independent of impermanence activation
        age.identityPaths = [
          "/persist/system/etc/ssh/ssh_host_ed25519_key"
        ];

        environment.systemPackages = [
          inputs'.agenix.packages.agenix
        ];
      };
    };

    hm =
      { config, ... }:
      let
        inherit (config.home) persistence;
        inherit (persistence.default) persistentStoragePath;
        persistEnabled = lib.hasAttr "default" persistence && persistence.default.enable;
      in
      {
        imports = [
          inputs.agenix.homeManagerModules.default
        ];

        config = {
          age.identityPaths = lib.mkIf persistEnabled [
            "${persistentStoragePath}${config.home.homeDirectory}/.ssh/id_ed25519"
          ];

          home.packages = [
            inputs'.agenix.packages.agenix
          ];
        };
      };
  };
}

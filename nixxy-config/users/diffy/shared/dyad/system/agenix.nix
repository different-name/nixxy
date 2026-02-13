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
  };
}

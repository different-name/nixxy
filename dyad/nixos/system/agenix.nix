{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.dyad.system.agenix.enable = lib.mkEnableOption "agenix config";

  config = lib.mkIf config.dyad.system.agenix.enable {
    # access to the hostkey independent of impermanence activation
    age.identityPaths = [
      "/persist/system/etc/ssh/ssh_host_ed25519_key"
    ];

    environment.systemPackages = [
      inputs'.agenix.packages.agenix
    ];
  };
}

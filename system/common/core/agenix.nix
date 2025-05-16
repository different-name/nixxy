{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  options.nix-files.core.agenix.enable = lib.mkEnableOption "Agenix config";

  config = lib.mkIf config.nix-files.core.agenix.enable {
    # access to the hostkey independent of impermanence activation
    age.identityPaths = [
      "/persist/system/etc/ssh/ssh_host_ed25519_key"
    ];

    environment.systemPackages = [
      inputs.agenix.packages.${pkgs.system}.agenix
    ];
  };
}

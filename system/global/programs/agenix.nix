{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.agenix.nixosModules.default
  ];

  # access to the hostkey independent of impermanence activation
  age.identityPaths = [
    "/persist/system/etc/ssh/ssh_host_ed25519_key"
    "/persist/home/${config.nix-files.user}/.ssh/id_ed25519"
  ];
}

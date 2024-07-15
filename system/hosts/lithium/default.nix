{
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ../../global

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "lithium";
    hostId = "3d0eee50";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.${config.nix-files.user} = import ../../../home/hosts/lithium.nix;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

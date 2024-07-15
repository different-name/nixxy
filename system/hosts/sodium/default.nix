{
  inputs,
  config,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ../../global

    ../../extra/hardware/nvidia.nix

    ../../extra/programs/alvr.nix
    ../../extra/programs/goxlr-utility.nix

    ../../extra/services/keyd.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "sodium";
    hostId = "9471422d";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.${config.nix-files.user} = import ../../../home/hosts/sodium.nix;
  };

  environment.systemPackages = [
    outputs.packages.${pkgs.system}.openvr-advanced-settings
  ];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

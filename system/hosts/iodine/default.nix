{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ### required config

  networking = {
    hostName = "iodine";
    hostId = "294b0aee";
  };

  environment.etc.machine-id.source = ./machine-id;

  programs.nh.flake = "/home/iodine/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  ### modules

  nix-files = {
    users.iodine.enable = true;

    profiles.global.enable = true;

    services.minecraft-server.enable = true;
  };
}

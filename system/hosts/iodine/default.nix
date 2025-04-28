{inputs, ...}: let
  machine-id = "294b0aee9a634611a9ddef5e843f4035";
in {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ### modules

  nix-files = {
    users.iodine.enable = true;

    profiles.global.enable = true;

    services = {
      cloudflare-dyndns.enable = true;
      minecraft-server = {
        enable = true;
        maocraft.enable = true;
        buhguh.enable = true;
        maodded.enable = true;
      };
    };
  };

  ### required config

  networking = {
    hostName = "iodine";
    hostId = builtins.substring 0 8 machine-id;
  };

  environment.etc.machine-id.text = machine-id;

  programs.nh.flake = "/home/iodine/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

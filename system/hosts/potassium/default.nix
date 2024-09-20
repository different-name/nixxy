{inputs, ...}: let
  machine-id = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
in {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ### modules

  nix-files = {
    users.different.enable = true;

    profiles = {
      global.enable = true;
      graphical.enable = true;
      laptop.enable = true;
    };

    hardware.nvidia.enable = true;

    services.autologin = {
      enable = true;
      user = "different";
    };
  };

  ### host specific

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  ### required config

  networking = {
    hostName = "potassium";
    hostId = builtins.substring 0 8 machine-id;
  };

  environment.etc.machine-id.text = machine-id;

  programs.nh.flake = "/home/different/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

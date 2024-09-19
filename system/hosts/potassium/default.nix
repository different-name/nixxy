{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "potassium";
    hostId = "ea3a24c5";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users."different" = import "${self}/home/users/different/hosts/potassium.nix";
  };

  # nh default flake
  programs.nh.flake = "/home/different/nix-files";

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

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

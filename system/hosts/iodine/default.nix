{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "iodine";
    hostId = "294b0aee";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users."iodine" = import "${self}/home/users/iodine/hosts/iodine.nix";
  };

  # nh default flake
  programs.nh.flake = "/home/iodine/nix-files";

  nix-files = {
    users.iodine.enable = true;

    profiles.global.enable = true;

    services.minecraft-server.enable = true;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

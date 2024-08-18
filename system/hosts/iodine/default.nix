{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    ../../users/iodine.nix

    ../../common/global

    ../../common/extra/services/tailscale.nix

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "iodine";
    hostId = "294b0aee";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users."iodine" = import ../../../home/users/iodine/hosts/iodine.nix;
  };

  # nh default flake
  programs.nh.flake = "/home/iodine/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

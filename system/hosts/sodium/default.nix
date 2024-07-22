{
  inputs,
  config,
  self,
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

  nix-files.xDisplayScale = {
    enable = true;
    value = "1.5";
  };

  environment.systemPackages = [
    self.packages.${pkgs.system}.openvr-advanced-settings
    self.packages.${pkgs.system}.slimevr
  ];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

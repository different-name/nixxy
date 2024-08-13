{
  inputs,
  config,
  self,
  pkgs,
  ...
}: let
  user = config.nix-files.user;
in {
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
    interfaces.enp4s0.ipv4.addresses = [{
      address = "192.168.86.11";
      prefixLength = 24;
    }];
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users.${config.nix-files.user} = import ../../../home/hosts/sodium.nix;
  };

  nix-files.xDisplayScale = {
    enable = true;
    value = "1.5";
  };

  environment.systemPackages = with self.packages.${pkgs.system}; [
    openvr-advanced-settings
    slimevr
  ];

  systemd.tmpfiles.rules = [
    "d /home/${user}/HDD 0755 ${user} users -"
  ];

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}

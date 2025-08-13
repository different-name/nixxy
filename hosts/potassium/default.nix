{ inputs, self, ... }:
{
  imports = [
    # keep-sorted start
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    self.nixosModules.dyad
    self.nixosModules.tty1Autologin
    # keep-sorted end
  ];

  system.stateVersion = "24.05";

  dyad = {
    users.diffy.enable = true;

    profiles = {
      # keep-sorted start
      graphical-extras.enable = true;
      graphical.enable = true;
      minimal.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    # keep-sorted start block=yes newline_separated=yes
    hardware.nvidia.enable = true;

    services.syncthing.enable = true;

    system = {
      # keep-sorted start
      btrfs.enable = true;
      perpetual.enable = true;
      # keep-sorted end
    };
    # keep-sorted end
  };

  services.tty1Autologin = {
    enable = true;
    user = "diffy";
  };

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
}

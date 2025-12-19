{
  inputs,
  self,
  ...
}:
{
  imports = [
    # keep-sorted start
    inputs.nixos-hardware.nixosModules.common-cpu-amd
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

    hardware.nvidia.enable = true;

    services = {
      # keep-sorted start
      keyd.enable = true;
      syncthing.enable = true;
      xr.enable = true;
      # keep-sorted end
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };
  };

  services.tty1Autologin = {
    enable = true;
    user = "diffy";
  };

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
    GDK_SCALE = "2";
  };

  hardware.brillo.enable = true; # backlight control
  hardware.keyboard.qmk.enable = true;
  services.goxlr-utility.enable = true;
}

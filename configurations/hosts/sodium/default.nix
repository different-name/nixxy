{
  lib,
  inputs,
  self,
  ...
}:
self.lib.mkHost
  {
    hostName = "sodium";
    machineId = "9471422d94d34bb8807903179fb35f11";
    stateVersion = "24.05";
  }
  {
    imports = [
      ./hardware.nix
      ./disko.nix
      ./fancontrol.nix

      # keep-sorted start
      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      self.nixosModules.tty1Autologin
      # keep-sorted end
    ];

    dyad = {
      users.diffy.enable = true;

      profiles = {
        # keep-sorted start
        graphical.enable = true;
        minimal.enable = true;
        terminal.enable = true;
        # keep-sorted end
      };

      # keep-sorted start block=yes newline_separated=yes
      hardware.nvidia.enable = true;

      nix.build-host.enable = true;

      services = {
        # keep-sorted start
        keyd.enable = true;
        syncthing.enable = true;
        xr.enable = true;
        # keep-sorted end
      };
      # keep-sorted end
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

    # mirror audio from goxlr outputs to wivrn output
    services.pipewire.wireplumber.scripts = {
      autoConnectPorts = lib.singleton {
        output = {
          subject = "port.alias";
          leftPort = "GoXLR:monitor_FL";
          rightPort = "GoXLR:monitor_FR";
        };

        input = {
          subject = "port.alias";
          leftPort = "WiVRn:playback_1";
          rightPort = "WiVRn:playback_2";
        };
      };
    };
  }

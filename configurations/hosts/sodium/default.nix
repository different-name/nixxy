{
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

      inputs.nixos-hardware.nixosModules.common-cpu-amd
      inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    ### dyad modules
    dyad = {
      ## users
      users.different.enable = true;

      ## profiles
      profiles = {
        minimal.enable = true;
        terminal.enable = true;
        graphical.enable = true;
      };

      ## modules
      hardware.nvidia.enable = true;
      nix.build-host.enable = true;

      services = {
        keyd.enable = true;
        syncthing.enable = true;
        xr.enable = true;
      };

      system = {
        autologin = {
          enable = true;
          user = "different";
        };

        btrfs.enable = true;
      };
    };

    ### host specific

    environment.sessionVariables = {
      STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
      GDK_SCALE = "2";
    };

    hardware.keyboard.qmk.enable = true;
    services.goxlr-utility.enable = true;

    # mirror audio from goxlr outputs to wivrn output
    services.pipewire.wireplumber.scripts = {
      autoConnectPorts = [
        {
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
        }
      ];
    };
  }

{ inputs, self, ... }:
self.lib.mkHost
  {
    hostName = "iodine";
    machineId = "294b0aee9a634611a9ddef5e843f4035";
    stateVersion = "24.05";
  }
  {
    imports = [
      ./hardware.nix
      ./disko.nix

      # keep-sorted start
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      # keep-sorted end
    ];

    dyad = {
      users.diffy.enable = true;

      profiles = {
        # keep-sorted start
        minimal.enable = true;
        terminal.enable = true;
        # keep-sorted end
      };

      services = {
        # keep-sorted start block=yes
        caddy.enable = true;
        cloudflare-dyndns.enable = true;
        headscale.enable = true;
        minecraft-server = {
          # enable = true;
          # keep-sorted start
          buhguh.enable = true;
          maocraft.enable = true;
          maodded.enable = true;
          # keep-sorted end
        };
        # keep-sorted end
      };
    };
  }

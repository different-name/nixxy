{ inputs, self, ... }:
{
  imports = [
    # keep-sorted start
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    self.nixosModules.dyad
    # keep-sorted end
  ];

  system.stateVersion = "24.05";

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
      copyparty.enable = true;
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

{
  lib,
  inputs,
  self,
  ...
}:
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

      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

    ### dyad modules

    dyad = {
      ## users
      users.different.enable = true;

      ## profiles
      profiles.global.enable = true;

      ## modules
      nix.distributed-builds.enable = true;

      # services = {
      #   cloudflare-dyndns.enable = true;

      #   minecraft-server = {
      #     enable = true;
      #     maocraft.enable = true;
      #     buhguh.enable = true;
      #     maodded.enable = true;
      #   };
      # };
    };

    ### host specific

    # TODO temporary rollback on iodine for password issues
    security.sudo.wheelNeedsPassword = lib.mkForce false;
  }

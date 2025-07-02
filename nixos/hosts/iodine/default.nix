{ lib, config, ... }:
lib.nix-files.mkHost {
  inherit config;

  hostName = "iodine";
  machineId = "294b0aee9a634611a9ddef5e843f4035";
  diskConfiguration = ./_disk-configuration.nix;
  stateVersion = "24.05";

  content = {
    ### nix-files modules

    nix-files = {
      users.iodine.enable = true;

      profiles.global.enable = true;

      parts = {
        nix = {
          distributed-builds.enable = true;
        };

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
    };

    ### host specific

    # TODO temporary rollback on iodine for password issues
    security.sudo.wheelNeedsPassword = lib.mkForce false;
  };
}

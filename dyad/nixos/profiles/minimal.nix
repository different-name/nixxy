{ lib, config, ... }:
{
  options.dyad.profiles.minimal.enable = lib.mkEnableOption "minimal profile";

  config = lib.mkIf config.dyad.profiles.minimal.enable {
    services.fstrim.enable = true;

    dyad = {
      # keep-sorted start block=yes newline_separated=yes
      hardware.fwupd.enable = true;

      nix = {
        # keep-sorted start
        nix.enable = true;
        nixpkgs.enable = true;
        substituters.enable = true;
        # keep-sorted end
      };

      programs = {
        # keep-sorted start
        fish.enable = true;
        nh.enable = true;
        # keep-sorted end
      };

      services.openssh.enable = true;

      system = {
        # keep-sorted start
        agenix.enable = true;
        boot.enable = true;
        btrfs.enable = true;
        home-manager.enable = true;
        locale.enable = true;
        networking.enable = true;
        security.enable = true;
        persistence-wrapper.enable = true;
        # keep-sorted end
      };
      # keep-sorted end
    };
  };
}

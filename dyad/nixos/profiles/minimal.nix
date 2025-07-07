{ lib, config, ... }:
{
  options.dyad.profiles.minimal.enable = lib.mkEnableOption "minimal profile";

  config = lib.mkIf config.dyad.profiles.minimal.enable {
    services.fstrim.enable = true;

    dyad = {
      hardware.fwupd.enable = true;

      nix = {
        nix.enable = true;
        nixpkgs.enable = true;
        substituters.enable = true;
      };

      programs = {
        fish.enable = true;
        nh.enable = true;
      };

      services = {
        openssh.enable = true;
      };

      system = {
        agenix.enable = true;
        boot.enable = true;
        home-manager.enable = true;
        btrfs.enable = true;
        locale.enable = true;
        networking.enable = true;
        security.enable = true;

        persistence = {
          enable = true;

          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/root/.cache"
            "/var/cache"
            "/var/lib/systemd/timesync"
            "/root/.android"
          ];

          files = [
            "/var/lib/logrotate.status"
            "/var/lib/systemd/random-seed"
          ];
        };
      };
    };
  };
}

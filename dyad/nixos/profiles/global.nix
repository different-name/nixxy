{ lib, config, ... }:
{
  options.dyad.profiles.global.enable = lib.mkEnableOption "global profile";

  config = lib.mkIf config.dyad.profiles.global.enable {
    programs.mosh.enable = true;

    services.fstrim.enable = true;

    dyad = {
      hardware = {
        fwupd.enable = true;
      };

      nix = {
        nix.enable = true;
        nixpkgs.enable = true;
        substituters.enable = true;
      };

      programs = {
        ephemeralTools.enable = true;
        fish.enable = true;
        nh.enable = true;
      };

      services = {
        openssh.enable = true;
        tailscale.enable = true;
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

      theming = {
        catppuccin.enable = true;
      };
    };
  };
}

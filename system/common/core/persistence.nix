{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.nix-files.core.persistence.enable = lib.mkEnableOption "Persistence config";

  config = lib.mkIf config.nix-files.core.persistence.enable {
    environment.persistence."/persist/system" = {
      hideMounts = true;

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

    # needed for home-manager impermanence to mount it's directories
    programs.fuse.userAllowOther = true;
  };
}

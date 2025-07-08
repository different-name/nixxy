{
  lib,
  config,
  self,
  ...
}:
{
  imports = [
    self.nixosModules.impermanenceWrapper
  ];

  options.dyad.system.persistence-wrapper.enable = lib.mkEnableOption "persistence-wrapper config";

  config = lib.mkIf config.dyad.system.persistence-wrapper.enable {
    environment.persistence-wrapper = {
      enable = true;
      persistentStorage = "/persist/system";

      dirs = [
        # keep-sorted start
        "/root/.android"
        "/root/.cache"
        "/var/cache"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/timesync"
        "/var/log"
        # keep-sorted end
      ];

      files = [
        # keep-sorted start
        "/var/lib/logrotate.status"
        "/var/lib/systemd/random-seed"
        # keep-sorted end
      ];
    };

    # required for impermanence to function
    fileSystems."/persist".neededForBoot = true;
  };
}

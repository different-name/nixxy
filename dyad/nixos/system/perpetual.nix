{
  lib,
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    # keep-sorted start
    inputs.impermanence.nixosModules.default
    self.nixosModules.perpetual # impermanence option bindings
    # keep-sorted end
  ];

  options.dyad.system.persistence.enable = lib.mkEnableOption "persistence config";

  config = lib.mkIf config.dyad.system.persistence.enable {
    environment.persistence.default = {
      persistentStoragePath = "/persist/system";
      hideMounts = true;
      enableWarnings = true;
    };

    environment.perpetual.default = {
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

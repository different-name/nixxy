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
    {
      # required since other configs try to use 'default'
      environment.persistence.default.persistentStoragePath = lib.mkDefault "/persist/system";
    }
    # keep-sorted end
  ];

  options.dyad.system.perpetual.enable = lib.mkEnableOption "perpetual config";

  config = lib.mkIf config.dyad.system.perpetual.enable {
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

{
  lib,
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    inputs.impermanence.nixosModules.default
    self.nixosModules.perpetual # impermanence option bindings
  ];

  options.dyad.system.perpetual.enable = lib.mkEnableOption "perpetual config";

  config = lib.mkIf config.dyad.system.perpetual.enable {
    environment.persistence.default = {
      persistentStoragePath = "/persist/system";
      hideMounts = true;
      enableWarnings = true;
    };

    environment.perpetual.default = {
      enable = true;

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
        "/var/lib/logrotate.status"
        "/var/lib/systemd/random-seed"
      ];
    };

    # required for impermanence to function
    fileSystems."/persist".neededForBoot = true;
  };
}

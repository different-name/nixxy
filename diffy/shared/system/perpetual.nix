{
  bundleLib,
  inputs,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "system" "perpetual" ] {
  nixos = {
    imports = [
      inputs.impermanence.nixosModules.default
      self.nixosModules.perpetual # impermanence option bindings
    ];

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

  home-manager = {
    imports = [
      self.homeModules.perpetual # impermanence option bindings
    ];

    home.persistence.default = {
      persistentStoragePath = "/persist";
      hideMounts = true;
      enableWarnings = true;
    };

    home.perpetual.default = {
      enable = true;

      dirs = [
        # keep-sorted start
        "$dataHome/Trash"
        ".terminfo"
        "nixxy"
        # keep-sorted end
      ];
    };
  };
}

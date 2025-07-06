{ lib, config, ... }:
{
  options.dyad.hardware.fwupd.enable = lib.mkEnableOption "fwupd config";

  config = lib.mkIf config.dyad.hardware.fwupd.enable {
    services.fwupd.enable = true;

    dyad.system.persistence = {
      directories = map (path: "/var/lib/fwupd/${path}") [
        "metadata"
        "gnupg"
        "pki"
      ];

      files = map (path: "/var/lib/fwupd/${path}") [
        "pending.db"
      ];
    };
  };
}

{ lib, config, ... }:
{
  options.dyad.hardware.fwupd.enable = lib.mkEnableOption "fwupd config";

  config = lib.mkIf config.dyad.hardware.fwupd.enable {
    services.fwupd.enable = true;

    dyad.system.persistence =
      let
        fwuptDir = "/var/lib/fwupd";
      in
      {
        dirs = [
          # keep-sorted start
          "${fwuptDir}/gnupg"
          "${fwuptDir}/metadata"
          "${fwuptDir}/pki"
          # keep-sorted end
        ];

        files = [
          "${fwuptDir}/pending.db"
        ];
      };
  };
}

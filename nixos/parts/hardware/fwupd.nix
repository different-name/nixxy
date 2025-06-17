{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.hardware.fwupd.enable = lib.mkEnableOption "fwupd config";

  config = lib.mkIf config.nix-files.parts.hardware.fwupd.enable {
    services.fwupd.enable = true;

    environment.persistence."/persist/system" =
      lib.mkIf config.nix-files.parts.system.persistence.enable
      {
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

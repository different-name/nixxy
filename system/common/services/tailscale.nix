{
  lib,
  config,
  ...
}: {
  options.nix-files.services.tailscale.enable = lib.mkEnableOption "Tailscale config";

  config = lib.mkIf config.nix-files.services.tailscale.enable {
    services.tailscale.enable = true;

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}

{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.services.tailscale.enable = lib.mkEnableOption "Tailscale config";

  config = lib.mkIf config.nix-files.parts.services.tailscale.enable {
    services.tailscale.enable = true;

    environment.persistence."/persist/system" =
      lib.mkIf config.nix-files.parts.system.persistence.enable
        {
          directories = [
            "/var/lib/tailscale"
          ];
        };
  };
}

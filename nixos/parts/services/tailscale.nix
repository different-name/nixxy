{ lib, config, ... }:
{
  options.nix-files.parts.services.tailscale.enable = lib.mkEnableOption "tailscale config";

  config = lib.mkIf config.nix-files.parts.services.tailscale.enable {
    services.tailscale.enable = true;

    nix-files.parts.system.persistence = {
      directories = [
        "/var/lib/tailscale"
      ];
    };
  };
}

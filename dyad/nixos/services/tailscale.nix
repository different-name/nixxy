{ lib, config, ... }:
{
  options.dyad.services.tailscale.enable = lib.mkEnableOption "tailscale config";

  config = lib.mkIf config.dyad.services.tailscale.enable {
    services.tailscale.enable = true;

    environment.persistence-wrapper.dirs = [
      "/var/lib/tailscale"
    ];
  };
}

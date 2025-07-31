{ lib, config, ... }:
{
  options.dyad.services.caddy.enable = lib.mkEnableOption "caddy config";

  config = lib.mkIf config.dyad.services.caddy.enable {
    services.caddy.enable = true;

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "caddy" ] {
  nixos = {
    services.caddy.enable = true;

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    environment.perpetual.default.dirs = [
      {
        directory = "/var/lib/caddy";
        user = "caddy";
        group = "caddy";
      }
    ];
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "tailscale" ] {
  nixos = {
    services.tailscale.enable = true;

    environment.perpetual.default.dirs = [
      "/var/lib/tailscale"
    ];
  };
}

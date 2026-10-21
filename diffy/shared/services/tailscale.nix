{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "tailscale" ] {
  nixos = {
    services.tailscale.enable = true;

    keep.safe.dirs = [ "/var/lib/tailscale" ];
  };
}

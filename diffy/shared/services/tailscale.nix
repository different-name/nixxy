{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "tailscale" ] {
  nixos = {
    services.tailscale.enable = true;

    keep.persist.dirs."/var/lib/tailscale" = { };
  };
}

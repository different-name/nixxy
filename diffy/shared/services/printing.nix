{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "printing" ] {
  nixos = {
    services = {
      printing = {
        enable = true;
        # cups creates driverless queues itself, browsed only adds attack surface
        browsed.enable = false;
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };

    keep.persist.dirs."/var/lib/cups" = { };
  };
}

{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "tailscale" ] {
  nixos = { config, lib, ... }: {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--operator=diffy" ];
    };

    systemd.services.taildrop = {
      after = [
        "tailscaled.service"
        "tailscaled-set.service"
      ];
      requires = [ "tailscaled.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "diffy";
        ExecStart = "${lib.getExe' config.services.tailscale.package "tailscale"} file get --loop --conflict=rename ${config.users.users.diffy.home}";
        Restart = "always";
        RestartSec = 5;
        RestartSteps = 8;
        RestartMaxDelaySec = 600;
      };
    };

    keep.safe.dirs = [ "/var/lib/tailscale" ];
  };
}

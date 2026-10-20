{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "system" "network-tuning" ] {
  nixos = {
    # bbr and larger buffers keep long round trips (offsite backups) from stalling the uplink
    boot.kernelModules = [ "tcp_bbr" ];
    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.rmem_max" = 67108864;
      "net.core.wmem_max" = 67108864;
      "net.ipv4.tcp_rmem" = "4096 131072 67108864";
      "net.ipv4.tcp_wmem" = "4096 65536 67108864";
    };
  };
}

{ lib, config, ... }:
let
  serverDomain = "headscale.different-name.dev";
in
{
  options.dyad.services.headscale.enable = lib.mkEnableOption "headscale config";

  config = lib.mkIf config.dyad.services.headscale.enable {
    services.headscale = {
      enable = true;

      settings = {
        server_url = "https://${serverDomain}";
        listen_addr = "0.0.0.0:8080";
        grpc_listen_addr = "0.0.0.0:50443";
        disable_check_updates = true;

        dns = {
          base_domain = "ts.different-name.dev";
          nameservers.global = [
            "1.1.1.1"
            "1.0.0.1"
            "2606:4700:4700::1111"
            "2606:4700:4700::1001"
          ];
        };
      };
    };

    services.caddy.virtualHosts.${serverDomain}.extraConfig = ''
      reverse_proxy 127.0.0.1:8080
    '';

    networking.firewall.allowedTCPPorts = [ 50443 ];
    services.cloudflare-dyndns.domains = [ serverDomain ];

    environment.perpetual.default.dirs = [
      "/var/lib/headscale"
    ];
  };
}

{ bundleLib, ... }:
let
  domain = "hs.diffy.wtf";
  port = 8085;
in
bundleLib.mkEnableModule [ "dyad" "services" "headscale" ] {
  dyad.services.acme.enable = true;

  nixos = {
    services.headscale = {
      enable = true;
      address = "127.0.0.1";
      inherit port;

      settings = {
        server_url = "https://${domain}";

        # the desktops disable ipv6, so tailscale cannot assign the address
        prefixes.v6 = "";

        dns = {
          magic_dns = true;
          base_domain = "tail.diffy.wtf";
          nameservers.global = [
            "1.1.1.1"
            "1.0.0.1"
          ];
        };

        # tailscale's public relays stay in the map as a fallback
        derp.server = {
          enabled = true;
          region_id = 999;
          region_code = "argon";
          region_name = "argon";
          stun_listen_addr = "0.0.0.0:3478";
        };
      };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts.${domain} = {
        enableACME = true;
        # dns-01, nothing is served for the challenge
        acmeRoot = null;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_buffering off;
          '';
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 443 ];
      allowedUDPPorts = [ 3478 ];
    };

    environment.perpetual.default.dirs = [ "/var/lib/headscale" ];
  };
}

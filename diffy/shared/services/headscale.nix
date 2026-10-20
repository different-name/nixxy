{ bundleLib, ... }:
let
  domain = "hs.diffy.wtf";
  port = 8085;

  # personal devices reach everything, the work servers only each other, argon nothing
  policy = {
    hosts = {
      sodium = "100.64.0.1/32";
      potassium = "100.64.0.2/32";
      lithium = "100.64.0.3/32";
      argon = "100.64.0.4/32";
      ncmb1 = "100.64.0.5/32";
      ncmb2 = "100.64.0.6/32";
    };

    acls = [
      {
        action = "accept";
        src = [
          "sodium"
          "potassium"
          "lithium"
        ];
        dst = [ "*:*" ];
      }
      {
        action = "accept";
        src = [
          "ncmb1"
          "ncmb2"
        ];
        dst = [
          "ncmb1:*"
          "ncmb2:*"
        ];
      }
    ];
  };
in
bundleLib.mkEnableModule [ "dyad" "services" "headscale" ] {
  dyad.services = {
    acme.enable = true;
    nginx.enable = true;
  };

  nixos = { pkgs, ... }: {
    services.headscale = {
      enable = true;
      address = "127.0.0.1";
      inherit port;

      settings = {
        server_url = "https://${domain}";

        policy.path = pkgs.writeText "headscale-policy.json" (builtins.toJSON policy);

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

    services.nginx.virtualHosts.${domain} = {
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

      # api docs, external derp verification and apple/windows enrolment pages are not needed here
      locations."/swagger".return = "404";
      locations."/verify".return = "404";
      locations."/apple".return = "404";
      locations."/windows".return = "404";
    };

    networking.firewall = {
      allowedTCPPorts = [ 443 ];
      allowedUDPPorts = [ 3478 ];
    };

    environment.perpetual.default.dirs = [ "/var/lib/headscale" ];
  };
}

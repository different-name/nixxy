{ bundleLib, self, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "acme" ] {
  nixos = { config, ... }: {
    age.secrets."cloudflare/dns-token".file = self + /diffy/secrets/cloudflare/dns-token.age;

    # dns-01 through cloudflare, so certs work for names that are not publicly reachable
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "hello@different-name.dev";
        dnsProvider = "cloudflare";
        environmentFile = config.age.secrets."cloudflare/dns-token".path;
        # propagation checks pass before every cloudflare nameserver has the record
        extraLegoFlags = [
          "--dns.propagation.wait"
          "60s"
        ];
      };
    };

    keep.safe.dirs = [ "/var/lib/acme" ];
  };
}

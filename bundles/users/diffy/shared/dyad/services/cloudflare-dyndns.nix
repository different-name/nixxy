{ bundleLib, self, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "cloudflare-dyndns" ] {
  dyad.system.agenix.enable = true;

  nixos =
    { config, ... }:
    {
      age.secrets."tokens/cloudflare".file = self + /secrets/tokens/cloudflare.age;

      services.cloudflare-dyndns = {
        enable = true;
        apiTokenFile = config.age.secrets."tokens/cloudflare".path;
      };
    };
}

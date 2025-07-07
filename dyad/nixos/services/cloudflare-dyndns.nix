{
  lib,
  config,
  self,
  ...
}:
{
  options.dyad.services.cloudflare-dyndns.enable = lib.mkEnableOption "cloudflare-dyndns config";

  config = lib.mkIf config.dyad.services.cloudflare-dyndns.enable {
    age.secrets."different/tokens/cloudflare".file = self + /secrets/different/tokens/cloudflare.age;

    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.age.secrets."different/tokens/cloudflare".path;
    };
  };
}

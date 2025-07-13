{
  lib,
  config,
  self,
  ...
}:
{
  options.dyad.services.cloudflare-dyndns.enable = lib.mkEnableOption "cloudflare-dyndns config";

  config = lib.mkIf config.dyad.services.cloudflare-dyndns.enable {
    age.secrets."diffy/tokens/cloudflare".file = self + /secrets/diffy/tokens/cloudflare.age;

    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.age.secrets."diffy/tokens/cloudflare".path;
    };
  };
}

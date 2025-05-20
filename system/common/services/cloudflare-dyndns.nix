{
  lib,
  config,
  self,
  ...
}: {
  options.nix-files.services.cloudflare-dyndns.enable = lib.mkEnableOption "cloudflare-dyndns config";

  config = lib.mkIf config.nix-files.services.cloudflare-dyndns.enable {
    age.secrets."tokens/cloudflare".file = "${self}/secrets/tokens/cloudflare.age";

    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.age.secrets."tokens/cloudflare".path;
    };
  };
}

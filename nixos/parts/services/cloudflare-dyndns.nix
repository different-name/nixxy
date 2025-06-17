{
  lib,
  config,
  inputs,
  ...
}: {
  options.nix-files.parts.services.cloudflare-dyndns.enable =
    lib.mkEnableOption "cloudflare-dyndns config";

  config = lib.mkIf config.nix-files.parts.services.cloudflare-dyndns.enable {
    age.secrets."tokens/cloudflare".file = inputs.self + /secrets/tokens/cloudflare.age;

    services.cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.age.secrets."tokens/cloudflare".path;
    };
  };
}

{
  lib,
  config,
  self,
  ...
}:
let
  inherit (import "${self}/flake.nix") nixConfig;
in
{
  options.dyad.nix.substituters.enable = lib.mkEnableOption "substitutors config";

  config = lib.mkIf config.dyad.nix.substituters.enable {
    nix.settings = {
      substituters = nixConfig.trusted-substituters;
      inherit (nixConfig) trusted-public-keys;
    };
  };
}

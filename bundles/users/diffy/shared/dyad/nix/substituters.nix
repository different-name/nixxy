{ bundleLib, self, ... }:
let
  inherit (import "${self}/flake.nix") nixConfig;
in
bundleLib.mkEnableModule [ "dyad" "nix" "substituters" ] {
  nixos.nix.settings = {
    substituters = nixConfig.trusted-substituters;
    inherit (nixConfig) trusted-public-keys;
  };
}

{
  bundleLib,
  lib,
  inputs,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "terminal" "nixpkgs-review" ] {
  dyad.system.agenix.enable = true;

  home-manager =
    { pkgs, config, ... }:
    {
      age.secrets."tokens/nixpkgs-review".file = self + /secrets/tokens/nixpkgs-review.age;

      home.packages = lib.singleton (
        inputs.wrappers.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.nixpkgs-review;
          env.GITHUB_TOKEN_CMD = "cat ${config.age.secrets."tokens/nixpkgs-review".path}";
        }
      );

      home.perpetual.default.dirs = [
        "$cacheHome/nixpkgs-review"
      ];
    };
}

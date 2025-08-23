{ lib, inputs, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      self',
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      packages = lib.removeAttrs (lib.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // self'.packages // { inherit (self') sources; });
        directory = ./.;
      }) [ "default" ];
    };
}

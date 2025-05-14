{
  perSystem = {pkgs, ...}: {
    packages = {
      wivrn-solarxr = pkgs.callPackage ./wivrn-solarxr.nix {};
    };
  };
}

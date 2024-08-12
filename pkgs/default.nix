{
  perSystem = {pkgs, ...}: {
    packages = {
      openvr-advanced-settings = pkgs.callPackage ./openvr-advanced-settings {};
      slimevr = pkgs.callPackage ./slimevr {};
    };
  };
}

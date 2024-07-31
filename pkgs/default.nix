{
  perSystem = {pkgs, ...}: {
    packages = {
      alvr = pkgs.callPackage ./alvr {};
      openvr-advanced-settings = pkgs.callPackage ./openvr-advanced-settings {};
      slimevr = pkgs.callPackage ./slimevr {};
    };
  };
}

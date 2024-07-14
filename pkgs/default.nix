{
  perSystem = {pkgs, ...}: {
    packages = {
      ente-photos-desktop = pkgs.callPackage ./ente-photos-desktop {};
      vrcx = pkgs.callPackage ./vrcx {};
      alvr = pkgs.callPackage ./alvr {};
      openvr-advanced-settings = pkgs.callPackage ./openvr-advanced-settings {};
    };
  };
}

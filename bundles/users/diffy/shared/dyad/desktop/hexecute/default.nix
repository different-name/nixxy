{ bundleLib, inputs', ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "hexecute" ] {
  home-manager = {
    home.packages = [
      inputs'.hexecute.packages.hexecute
    ];

    home.perpetual.default.dirs = [
      "$configHome/hexecute"
    ];

    # TODO setup json config
  };
}

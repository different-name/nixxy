{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "ddcutil" ] {
  nixos =
    { pkgs, ... }:
    {
      hardware.i2c.enable = true;

      environment.systemPackages = with pkgs; [ ddcutil ];
    };
}

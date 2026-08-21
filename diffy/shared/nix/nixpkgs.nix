{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "nixpkgs" ] {
  nixos = {
    nixpkgs.config = {
      allowUnfree = true;
      segger-jlink.acceptLicense = true;
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

    documentation.nixos.enable = false;
  };
}

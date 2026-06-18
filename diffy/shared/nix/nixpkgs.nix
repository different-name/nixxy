{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "nixpkgs" ] {
  nixos = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        segger-jlink.acceptLicense = true;
      };

      overlays = [
        (final: prev:
        let
          name = "wayvr";
          version = "ad9dd7872c3f18a62ae0634132a9b7dde734c473";
          src = final.fetchFromGitHub {
            owner = "SparkyTD";
            repo = "wayvr";
            rev = "ad9dd7872c3f18a62ae0634132a9b7dde734c473";
            hash = "sha256-kRoLgQqT3TUvfXUVXpsKFykmE3z1XtUeKtV/teMMOn4=";
          };
        in
        {
          ${name} = prev.${name}.overrideAttrs (oldAttrs: rec {
            inherit version src;

            cargoDeps = prev.rustPlatform.fetchCargoVendor {
              inherit src;
              name = "${name}-${version}-vendor";
              hash = "sha256-Q4gJcO+CzMLaI8AOADq6NR0gA9l9Sje1xd78OKX4cy0=";
            };
          });
        })
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  };
}

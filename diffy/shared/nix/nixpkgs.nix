{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "nix" "nixpkgs" ] {
  nixos = {
    nixpkgs = {
      config = {
        allowUnfree = true;
        segger-jlink.acceptLicense = true;
      };

      overlays = [
        (
          final: prev:
          let
            name = "wayvr";
            version = "28da0347aed282b0431e6615a9ef19853f864835";
            src = final.fetchFromGitHub {
              owner = "wayvr-org";
              repo = "wayvr";
              rev = "28da0347aed282b0431e6615a9ef19853f864835";
              hash = "sha256-Q48DIfrszT2rIe4zSqDn0vrQ8xO6qjbnPqCtH52edDk=";
            };
          in
          {
            ${name} = prev.${name}.overrideAttrs (_oldAttrs: rec {
              inherit version src;

              cargoDeps = prev.rustPlatform.fetchCargoVendor {
                inherit src;
                name = "${name}-${version}-vendor";
                hash = "sha256-Q4gJcO+CzMLaI8AOADq6NR0gA9l9Sje1xd78OKX4cy0=";
              };
            });
          }
        )
      ];
    };

    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

    documentation.nixos.enable = false;
  };
}

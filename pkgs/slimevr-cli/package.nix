{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  solarXrProtocol = fetchFromGitHub {
    owner = "SlimeVR";
    repo = "SolarXR-Protocol";
    rev = "737d007b4f439d98f94f8c00fac4b058e4a4317d";
    hash = "sha256-4UsuVEsNAGqbZ/Lkgc/Dv0Z2hn/3ABkn0RK/95FpbXs=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "slimevr-cli";
  version = "0.1.0";

  src = builtins.path {
    path = ./src;
    name = "${finalAttrs.pname}-src";
  };

  prePatch = ''
    cp -r ${solarXrProtocol}/protocol/typescript/src ./scripts/SolarXR-Protocol-ts
  '';

  npmDepsHash = "sha256-g3mZNKHoGDNj+ZaedZj6G8Ub//OAqU1dw4luv6ksUTo=";

  meta = {
    description = "A very simple command line tool for interacting with the SlimeVR server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ different-name ];
    mainProgram = "slimevr-cli";
  };
})

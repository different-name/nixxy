{
  pkgs,
  lib,
  ...
}:
# slimevr tracker support for wivrn
# https://lvra.gitlab.io/docs/fossvr/wivrn/#nixos-setup
(pkgs.wivrn.overrideAttrs (old: rec {
  version = "3cea1afee2c29d00056b3a10687431990ef860c8";
  src = pkgs.fetchFromGitHub {
    owner = "notpeelz";
    repo = "WiVRn";
    rev = version;
    hash = "sha256-zaJoW5rnzcKn/vQrepJSFEJU1b3eyBwu1ukJLCjtJtE=";
  };
  cmakeFlags =
    old.cmakeFlags
    ++ [
      (lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)
    ];
}))

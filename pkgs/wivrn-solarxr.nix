{
  pkgs,
  nvSources,
  lib,
  ...
}:
# slimevr tracker support for wivrn
# https://lvra.gitlab.io/docs/fossvr/wivrn/#nixos-setup
(pkgs.wivrn.overrideAttrs (old: {
  inherit (nvSources.wivrn) version src;
  pname = "wivrn-solarxr";
  cmakeFlags =
    (old.cmakeFlags or [])
    ++ [(lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)];
}))

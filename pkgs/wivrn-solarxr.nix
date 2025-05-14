{
  pkgs,
  nvSources,
  lib,
  ...
}:
# slimevr tracker support for wivrn
# https://lvra.gitlab.io/docs/fossvr/wivrn/#nixos-setup
pkgs.wivrn.overrideAttrs (old: {
  inherit (nvSources.wivrn) version src;
  pname = "wivrn-solarxr";
  cmakeFlags =
    (old.cmakeFlags or [])
    ++ [(lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)];

  monado = pkgs.applyPatches {
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "c80de9e7cacf2bf9579f8ae8c621d8bf16e85d6c";
      hash = "sha256-ciH26Hyr8FumB2rQB5sFcXqtcQ1R84XOlphkkLBjzvA=";
    };

    patches = [
      "${pkgs.path}/pkgs/by-name/wi/wivrn/force-enable-steamvr_lh.patch"
    ];

    postPatch = ''
      ${nvSources.wivrn.src}/patches/apply.sh ${nvSources.wivrn.src}/patches/monado/*
    '';
  };
})

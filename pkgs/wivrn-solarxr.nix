{
  pkgs,
  nvSources,
  lib,
  ...
}:
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
      rev = "2a6932d46dad9aa957205e8a47ec2baa33041076";
      hash = "sha256-Bus9GTNC4+nOSwN8pUsMaFsiXjlpHYioQfBLxbQEF+0=";
    };

    patches = [
      "${pkgs.path}/pkgs/by-name/wi/wivrn/force-enable-steamvr_lh.patch"
    ];

    postPatch = ''
      ${nvSources.wivrn.src}/patches/apply.sh ${nvSources.wivrn.src}/patches/monado/*
    '';
  };
})

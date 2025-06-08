{
  lib,
  pkgs,
  sources,
  ...
}:
pkgs.wivrn.overrideAttrs (final: prev: rec {
  inherit (sources.wivrn-solarxr) pname version src;

  cmakeFlags =
    (prev.cmakeFlags or [])
    ++ [(lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)];

  monado = pkgs.applyPatches {
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = builtins.readFile (src + /monado-rev);
      hash = "sha256-KSHnJ+H/JdLFg/oFERDk+dXTJY44yUP04WHxa7xp6LY=";
    };

    postPatch = ''
      ${sources.wivrn-solarxr.src}/patches/apply.sh ${sources.wivrn-solarxr.src}/patches/monado/*
    '';
  };
})

{
  lib,
  pkgs,
  sources,
  ...
}:
pkgs.wivrn.overrideAttrs (final: prev: {
  inherit (sources.wivrn-solarxr) pname version src;

  cmakeFlags =
    (prev.cmakeFlags or [])
    ++ [(lib.cmakeBool "WIVRN_FEATURE_SOLARXR" true)];

  monado = pkgs.applyPatches {
    src = pkgs.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "74772316c4516c48e132e5936626b972db61a3c3";
      hash = "sha256-6wMTN7znss6iDW+BsuxrVu4BaF8kbDUGuisHzhg2lbI=";
    };

    postPatch = ''
      ${sources.wivrn-solarxr.src}/patches/apply.sh ${sources.wivrn-solarxr.src}/patches/monado/*
    '';
  };

  postUnpack = ''
    ourMonadoRev="${final.monado.src.rev}"
    theirMonadoRev=$(cat ${final.src.name}/monado-rev)
    if [ ! "$theirMonadoRev" == "$ourMonadoRev" ]; then
      echo "Our Monado source revision doesn't match CMakeLists.txt." >&2
      echo "  theirs: $theirMonadoRev" >&2
      echo "    ours: $ourMonadoRev" >&2
      return 1
    fi
  '';
})

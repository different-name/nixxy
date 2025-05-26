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

  # monado = pkgs.applyPatches {
  #   src = pkgs.fetchFromGitLab {
  #     domain = "gitlab.freedesktop.org";
  #     owner = "monado";
  #     repo = "monado";
  #     rev = "2a6932d46dad9aa957205e8a47ec2baa33041076";
  #     hash = "sha256-Bus9GTNC4+nOSwN8pUsMaFsiXjlpHYioQfBLxbQEF+0=";
  #   };

  #   postPatch = ''
  #     ${sources.wivrn-solarxr.src}/patches/apply.sh ${sources.wivrn-solarxr.src}/patches/monado/*
  #   '';
  # };

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

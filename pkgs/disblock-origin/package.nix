{
  lib,
  inputs,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "disblock-origin";
  version = inputs.disblock-origin.shortRev;
  src = inputs.disblock-origin.outPath;

  installPhase = ''
    mkdir -p $out/share
    cp -r $src/. $out/share/
  '';

  meta = {
    description = "An ad-blocker \"Theme\" for Discord that hides all Nitro and \"boost\" upsells, alongside some annoyances.";
    homepage = "https://git.allpurposem.at/mat/Disblock-Origin.git";
    maintainers = with lib.maintainers; [ different-name ];
    platforms = lib.platforms.all;
  };
}

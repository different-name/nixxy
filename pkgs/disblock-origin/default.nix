{
  sources,
  lib,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  inherit (sources.disblock-origin) pname version src;

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

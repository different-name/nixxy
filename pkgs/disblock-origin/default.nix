{
  pkgs,
  sources,
  lib,
  ...
}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  inherit (sources.disblock-origin) pname version src;

  installPhase = ''
    mkdir -p $out/share
    cp -r $src/. $out/share/
  '';

  meta = {
    description = "An ad-blocker \"Theme\" for Discord that hides all Nitro and \"boost\" upsells, alongside some annoyances.";
    homepage = "https://git.allpurposem.at/mat/Disblock-Origin.git";
    mainProgram = "disblock-origin";
    platforms = lib.platforms.all;
  };
})

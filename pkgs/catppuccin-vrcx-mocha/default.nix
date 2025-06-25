{
  lib,
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "catppuccin-vrcx-mocha";
  version = "0.1.0";
  src = builtins.path {
    path = ./.;
    name = finalAttrs.pname + "-src";
  };

  installPhase = ''
    mkdir -p $out/share
    cp $src/vrcx-catppuccin.css $out/share/
  '';

  meta = {
    description = "Catppuccin mocha theme for VRCX";
    platforms = lib.platforms.all;
  };
})

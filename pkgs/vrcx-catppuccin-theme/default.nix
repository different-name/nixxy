{
  pkgs,
  lib,
  ...
}:
pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vrcx-catppuccin-theme";
  version = "0.1.0";
  src = builtins.path {
    path = ./.;
    name = finalAttrs.pname;
  };

  unpackPhase = null;

  installPhase = ''
    mkdir -p $out/share
    cp $src/vrcx-catppuccin.css $out/share/
  '';

  meta = {
    description = "Catppuccin mocha theme for VRCX";
    platforms = lib.platforms.all;
  };
})

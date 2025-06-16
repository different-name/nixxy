{
  pkgs,
  lib,
  ...
}:
pkgs.stdenvNoCC.mkDerivation {
  pname = "vrcx-catppuccin-theme";
  version = "0.1.0";
  src = ./.;

  unpackPhase = null;

  installPhase = ''
    mkdir -p $out/share
    cp $src/vrcx-catppuccin.css $out/share/
  '';

  meta = {
    description = "Catppuccin mocha theme for VRCX";
    platforms = lib.platforms.all;
  };
}

{ lib, stdenvNoCC, ... }:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "catppuccin-firefox-mocha";
  version = "1.0";
  src = builtins.path {
    path = ./.;
    name = finalAttrs.pname + "-src";
  };

  installPhase =
    let
      extensionsPath = "$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
    in
    ''
      mkdir -p ${extensionsPath}
      cp $src/{6674bcec-dcb3-437b-ac3d-4c26bc92d6eb}.xpi ${extensionsPath}/
    '';

  meta = {
    description = "Unofficial Catppuccin Mocha theme for Firefox";
    platforms = lib.platforms.all;
  };
})

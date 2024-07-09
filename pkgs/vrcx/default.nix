{
  stdenv,
  wine,
  lib,
  fetchzip,
  makeWrapper,
}: let
  pname = "vrcx";
  version = "2024.06.12";
  version-short = builtins.replaceStrings ["."] [""] version;

  src = fetchzip {
    url = "https://github.com/vrcx-team/VRCX/releases/download/v${version}/VRCX_${version-short}.zip";
    hash = "sha256-UX6W1PZRAKEYBdN8IcJ4+MZW7yj4J/b1qONt7wSrtZY=";
    stripRoot = false;
  };
  # meta = {
  #   description = "Friendship management tool for VRChat";
  #   homepage = "https://github.com/vrcx-team/VRCX";
  #   license = with lib.licenses; [
  #     mit
  #   ];
  #   maintainers = with lib.maintainers; [ different ];
  #   mainProgram = "vrcx";
  #   platforms = [ "x86_64-linux" ];
  # };
in
  stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      makeWrapper
    ];

    builtInputs = [
      wine
    ];

    postUnpack = ''
      mkdir -p $out/vrcx
      cp -r $src/. $out/vrcx
      chmod +x $out/vrcx/VRCX.exe
    '';

    installPhase = ''
      wrapProgram $out/vrcx/VRCX.exe --run "${wine}/bin/wine PROGRAM"
    '';
  }

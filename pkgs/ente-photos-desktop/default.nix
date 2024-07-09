{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  yarn,
  fixup_yarn_lock,
}: let
  pname = "ente-photos-desktop";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    rev = "ac4a68d";
    hash = "sha256-E5b9eTisGV0JZtgDm+Nuf9Rdhx2e6+JAnDiQAoGBzw4=";
    fetchSubmodules = true;
  };
in
  stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [
      nodejs
      yarn
      fixup_yarn_lock
    ];

    configurePhase = ''
      runHook preConfigure

      cd desktop
      yarn install
      patchShebangs node_modules
      cd ..

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      cd desktop
      yarn build
      cd ..

      runHook postBuild
    '';
  }

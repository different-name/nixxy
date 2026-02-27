{
  lib,
  inputs,
  buildNpmPackage,
  copyDesktopItems,
  makeDesktopItem,
  electron,
}:
buildNpmPackage {
  pname = "oscgoesbrrr";
  version = inputs.oscgoesbrrr.shortRev;
  src = inputs.oscgoesbrrr.outPath;

  npmDepsHash = "sha256-krdVx5Ci/hsQMzXhRmMbSZ+3YoQOTKH24Ejd4ykopdE=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs = [
    copyDesktopItems
  ];

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    npm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/oscgoesbrrr"
    cp -r . "$out/share/lib/oscgoesbrrr/"

    install -m 444 -D "src/icons/ogb-logo.png" "$out/share/icons/hicolor/512x512/apps/oscgoesbrrr.png"

    makeShellWrapper '${lib.getExe electron}' "$out/bin/oscgoesbrrr" \
      --add-flags "$out/share/lib/oscgoesbrrr" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "oscgoesbrrr";
      exec = "oscgoesbrrr";
      icon = "oscgoesbrrr";
      desktopName = "OscGoesBrrr";
      comment = "VRChat OSC haptic control";
      categories = [
        "Game"
        "Utility"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "Make haptics in real life go BRRR from VRChat";
    homepage = "https://github.com/OscToys/OscGoesBrrr";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ different-name ];
    mainProgram = "oscgoesbrrr";
    platforms = lib.platforms.all;
  };
}

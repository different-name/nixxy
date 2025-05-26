{
  lib,
  pkgs,
  sources,
  ...
}:
pkgs.buildNpmPackage (finalAttrs: {
  inherit (sources.osc-goes-brrr) pname version src;

  npmDepsHash = "sha256-HObRprVAnJWSay8x7+Apkp0sKx1CpnjIB1ze4xks/Lo=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  nativeBuildInputs = with pkgs; [
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

    mkdir -p "$out/share/lib/osc-goes-brrr"
    cp -r . "$out/share/lib/osc-goes-brrr/"

    install -m 444 -D "src/icons/ogb-logo.png" "$out/share/icons/hicolor/512x512/apps/osc-goes-brrr.png"

    makeShellWrapper '${lib.getExe pkgs.electron}' "$out/bin/osc-goes-brrr" \
      --add-flags "$out/share/lib/osc-goes-brrr" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "osc-goes-brrr";
      exec = "osc-goes-brrr";
      icon = "osc-goes-brrr";
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
    # license = lib.licenses.cc-by-nc-sa-40;
    mainProgram = "osc-goes-brrr";
    platforms = lib.platforms.all;
  };
})

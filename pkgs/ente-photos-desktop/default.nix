{
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
}: let
  pname = "ente-photos-desktop";
  version = "1.7.2";

  src = fetchurl {
    url = "https://github.com/ente-io/photos-desktop/releases/download/v${version}/ente-${version}-x86_64.AppImage";
    hash = "sha256-k8+E+c42hCXmPlIHe3mvjJwPsuxHGQ9SL6tLGGdM2i8=";
  };

  desktopEntry = makeDesktopItem {
    name = "ente-photos";
    desktopName = "Ente Photos";
    exec = "ente-photos-desktop";
    icon = "ente-photos";
    comment = "End to End Encrypted Cloud Photo Storage";
  };

  icon = fetchurl {
    url = "https://github.com/ente-io/ente/raw/d7cd2cecbc820e949ec5865f27bd63b3657dc3d4/desktop/build/icon.png";
    hash = "sha256-UGPpppDR9OrdG/a5ILBz/3k1/rlEW6BWozzn5MV0ac8=";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${desktopEntry}/share/applications/ente-photos.desktop $out/share/applications/ente-photos.desktop
      install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/ente-photos.png
    '';

    meta = with lib; {
      description = "End to End Encrypted Cloud Photo Storage";
      homepage = "https://ente.io/";
      changelog = "https://github.com/ente-io/photos-desktop/releases/tag/v${version}";
      license = licenses.agpl3Only;
      mainProgram = "ente-photos";
      maintainers = with maintainers; [different];
      platforms = ["x86_64-linux"];
    };
  }

{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  vivaldi-ffmpeg-codecs,
  glib,
  nss,
  dbus,
  at-spi2-core,
  cups,
  gtk3,
  pango,
  cairo,
  xorg,
  mesa,
  expat,
  libxcb,
  libxkbcommon,
  systemd,
  alsa-lib,
  gcc,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "spinshare-client-next";
  version = "3.31.0";

  src = fetchzip {
    url = "https://github.com/SpinShare/client-next/releases/download/v${finalAttrs.version}/SpinShare-linux-x64-${finalAttrs.version}.zip";
    hash = "sha256-LPfN/QTORRSYhHepRqrQ+wfYlzc8JAb1TCaPUEG6kKo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    vivaldi-ffmpeg-codecs
    glib
    nss
    dbus
    at-spi2-core
    cups
    gtk3
    pango
    cairo
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    mesa
    expat
    libxcb
    libxkbcommon
    systemd
    alsa-lib
    gcc
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib
    cp -r . $out/lib

    makeShellWrapper $out/lib/${finalAttrs.pname} $out/bin/${finalAttrs.pname} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}" \

    runHook postInstall
  '';

  meta = {
    description = "A modern cross-platform custom chart client for SpinShare";
    homepage = "https://github.com/spinshare/client-next";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ different-name ];
    mainProgram = "spinshare-client-next";
  };
})

# WIP for building from source, currently fails

# {
#   buildNpmPackage,
#   fetchFromGitHub,
#   ...
# }:
# buildNpmPackage (finalAttrs: {
#   pname = "spinshare-client-next";
#   version = "3.31.0";

#   src = fetchFromGitHub {
#     owner = "SpinShare";
#     repo = "client-next";
#     rev = "add98e17663a13d75dd0fa475ea55f4e4939c528";
#     hash = "sha256-Vi3RFOFShbWCz60ulWDRHiuSlwNwIKEzXxTNMUDHRTE=";
#   };

#   npmDepsHash = "sha256-JbjKV2i6ZJrGOs0VIZJpt39yv7hKojfwFNmCGiEGvXM=";

#   makeCacheWritable = true;
#   npmRebuildFlags = [ "--ignore-scripts" ];

#   buildPhase = ''
#     npm run make
#   '';
# })

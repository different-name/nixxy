{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  rustPlatform,
  pkg-config,
  jack2,
  alsaLib,
  openssl,
  pipewire,
  llvmPackages,
  clang,
  libva,
  ffmpeg-full,
  vulkan-tools-lunarg,
  vulkan-headers,
  vulkan-loader,
  vulkan-validation-layers,
  libunwind,
  xorg,
  git,
  nasm,
  # libgcc,
  # libGL,
  # libxkbcommon,
  # wayland,
  # binutils-unwrapped,
  # glib,
  # cairo,
  # pango,
  # atk,
  # gdk-pixbuf,
  # gtk3,
  # python3,
  # libxkbcommon
}: let
  pname = "alvr";
  version = "20.9.1";

  src = fetchFromGitHub {
    owner = "alvr-org";
    repo = "ALVR";
    rev = "70bba37";
    hash = "sha256-ettyLuMf6/0ihb6skq2r+u/KMgCmeomTySDF20Arbac=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  x264-src = fetchzip {
    url = "https://code.videolan.org/videolan/x264/-/archive/c196240409e4d7c01b47448d93b1f9683aaa7cf7/x264-c196240409e4d7c01b47448d93b1f9683aaa7cf7.tar.bz2";
    hash = "sha256-5v4svrf+ZKo/KCvMtnkvHKv1MVJbXDNSjN49TTpsuAo=";
  };

  ffmpeg-n6-src = fetchzip {
    url = "https://codeload.github.com/FFmpeg/FFmpeg/zip/n6.0";
    hash = "sha256-RVbgsafIbeUUNXmUbDQ03ZN42oaUo0njqROo7KOQgv0=";
    extension = ".zip";
  };

  ffmpeg-n12-src = fetchzip {
    url = "https://github.com/FFmpeg/nv-codec-headers/archive/refs/tags/n12.1.14.0.zip";
    hash = "sha256-WJYuFmMGSW+B32LwE7oXv/IeTln6TNEeXSkquHh85Go=";
  };
in
  rustPlatform.buildRustPackage rec {
    inherit pname version src;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
      outputHashes = {
        "openxr-0.17.1" = "sha256-fG/JEqQQwKP5aerANAt5OeYYDZxcvUKCCaVdWRqHBPU=";
        "settings-schema-0.2.0" = "sha256-luEdAKDTq76dMeo5kA+QDTHpRMFUg3n0qvyQ7DkId0k=";
      };
    };

    nativeBuildInputs = [
      pkg-config
      clang
      git
      nasm
    ];

    buildInputs = [
      jack2
      alsaLib
      openssl
      pipewire
      libva
      (ffmpeg-full.overrideAttrs (oldAttrs: {
        withUnfree = true;
        withSamba = null;
      }))
      vulkan-tools-lunarg
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers
      libunwind
      xorg.libX11
      xorg.libXrandr

      # binutils-unwrapped
      # glib
      # cairo
      # pango
      # atk
      # gdk-pixbuf
      # gtk3
      # python3 # for the xcb crate
      # libxkbcommon
    ];

    patches = [
      ./download.patch
    ];

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    buildPhase = ''
      mkdir -p /build/download
      cp -r ${x264-src} /build/download/x264-c196240409e4d7c01b47448d93b1f9683aaa7cf7
      cp -r ${ffmpeg-n6-src} /build/download/FFmpeg-n6.0
      cp -r ${ffmpeg-n12-src} /build/download/nv-codec-headers-n12.1.14.0
      chmod -R u+w /build/download/
      patchShebangs --build /build/download/x264-c196240409e4d7c01b47448d93b1f9683aaa7cf7/configure

      cargo xtask prepare-deps --platform linux
      cargo xtask build-streamer --release
    '';

    meta = with lib; {
      description = "Stream VR games from your PC to your headset via Wi-Fi";
      homepage = "https://github.com/alvr-org/ALVR/";
      changelog = "https://github.com/alvr-org/ALVR/releases/tag/v${version}";
      license = licenses.mit;
      mainProgram = "alvr";
      maintainers = with maintainers; [passivelemon];
      platforms = ["x86_64-linux"];
    };
  }

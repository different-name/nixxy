{
  stdenv,
  autoPatchelfHook,
  lib,
  fetchurl,
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
  wayland,
  libGL,
  wayland-protocols,
}: let
  pname = "alvr";
  version = "20.9.1";

  src = fetchurl {
    url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/alvr_launcher_linux.tar.gz";
    hash = "sha256-c2IBs/tS1Cvf20Pg89JO2jbqNF5F8KPsRmZS0/hnDio=";
  };
in
  stdenv.mkDerivation rec {
    inherit pname version src;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      pkg-config
      jack2
      alsaLib
      openssl
      pipewire
      libva
      vulkan-tools-lunarg
      vulkan-headers
      vulkan-loader
      vulkan-validation-layers
      libunwind
      xorg.libX11
      xorg.libXrandr
      wayland
      libGL
      wayland-protocols
    ];

    sourceRoot = "alvr_launcher_linux";

    installPhase = ''
      runHook preInstall
      install -m755 -D "ALVR Launcher" "$out/bin/${pname}"
      runHook postInstall
    '';

    postFixup = ''
      patchelf $out/bin/${pname} \
        --add-rpath ${lib.makeLibraryPath buildInputs}
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

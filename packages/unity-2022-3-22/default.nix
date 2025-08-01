{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
  androidenv,
  jdk11,
  xar,
  cpio,
  withAndroidSupport ? true,
  withWindowsSupport ? true,
  makeWrapper,
  ...
}:
let
  androidSupport = fetchurl {
    url = "https://download.unity3d.com/download_unity/887be4894c44/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-2022.3.22f1.pkg";
    hash = "sha256-Vqk8HgnFsUzjLvjIhIdJTLFHpyE6UDhwR7hN7/Jjpak=";
  };

  windowsSupport = fetchurl {
    url = "https://download.unity3d.com/download_unity/887be4894c44/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-2022.3.22f1.pkg";
    hash = "sha256-iBGBpsg3IwooTqQSC/y14qq5QLuQEOvftQ07iGXCBZ0=";
  };

  ndkVersion = "23.1.7779620";
  androidComposition = androidenv.composeAndroidPackages {
    buildToolsVersions = [ "32.0.0" ];
    cmdLineToolsVersion = "6.0";
    platformVersions = [
      "31"
      "32"
    ];
    platformToolsVersion = "34.0.4"; # should be 32.0.0
    toolsVersion = "26.1.1";

    includeNDK = true;
    ndkVersions = [ ndkVersion ];

    includeSources = false;
    useGoogleAPIs = false;
  };
  androidSdk = androidComposition.androidsdk + "/libexec/android-sdk";

  playbackEnginesPath = "Editor/Data/PlaybackEngines";
  androidSupportPath = playbackEnginesPath + "/AndroidPlayer";
  androidSdkPath = androidSupportPath + "/SDK";
  androidNdkPath = androidSupportPath + "/NDK";
  openJdkPath = androidSupportPath + "/OpenJDK";
  windowsSupportPath = playbackEnginesPath + "/WindowsStandaloneSupport";

  extractSupportPkg =
    name: src: enabled:
    lib.optionalString enabled ''
      (
        mkdir -p ${name}-support
        cd ${name}-support
        xar -xf "${src}"
        mkdir -p payload-content
        cd payload-content
        gzip -dc ../TargetSupport.pkg.tmp/Payload | cpio -id
      )
    '';
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "unity-2022-3-22";
  version = "2022.3.22f1";

  src = fetchurl {
    url = "https://download.unity3d.com/download_unity/887be4894c44/LinuxEditorInstaller/Unity-2022.3.22f1.tar.xz";
    hash = "sha256-eE//d2kFHA9p7bA52NCUMeeuQASmSh20QDcJ3biKpQY=";
  };

  nativeBuildInputs = [
    xar
    cpio
    makeWrapper
  ];

  fhsEnv = import ./fhs-env.nix {
    inherit (finalAttrs) pname version;
    inherit buildFHSEnv;
  };

  unpackPhase = ''
    runHook preUnpack

    tar -xf "$src"
    ${extractSupportPkg "android" androidSupport withAndroidSupport}
    ${extractSupportPkg "windows" windowsSupport withWindowsSupport}

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R Editor $out/

    ${lib.optionalString withAndroidSupport ''
      mkdir -p $out/${androidSupportPath}
      cp -r android-support/payload-content/. $out/${androidSupportPath}

      mkdir -p $out/${androidSdkPath}
      (
        cd ${androidSdk}
        cp -r build-tools cmdline-tools platforms platform-tools tools \
          $out/${androidSdkPath}/
      )

      mkdir -p $out/${androidNdkPath}
      cp -r ${androidSdk}/ndk/${ndkVersion}/. $out/${androidNdkPath}

      mkdir -p $out/${openJdkPath}
      cp -r ${jdk11}/lib/openjdk/. $out/${openJdkPath}
    ''}

    ${lib.optionalString withWindowsSupport ''
      mkdir -p $out/${windowsSupportPath}
      cp -r windows-support/payload-content/. $out/${windowsSupportPath}
    ''}

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    mkdir -p $out/bin
    makeWrapper ${lib.getExe finalAttrs.fhsEnv} $out/bin/${finalAttrs.pname} \
      --add-flags $out/Editor/Unity

    runHook postFixup
  '';

  dontBuild = true;

  meta = {
    description = "Build 2D and 3D experiences in any style, for any platform.";
    homepage = "https://unity.com/products/unity-engine";
    downloadPage = "https://unity.com/releases/editor/whats-new/2022.3.22";
    changelog = "https://unity.com/releases/editor/whats-new/2022.3.22#notes";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ different-name ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = finalAttrs.pname;
  };
})

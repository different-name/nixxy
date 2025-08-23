{
  lib,
  stdenv,
  slimevr,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "slimevr-udev-rules";
  inherit (slimevr) src version;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp $src/gui/src-tauri/69-slimevr-devices.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "udev rules for SlimeVR";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ different-name ];
    platforms = platforms.linux;
    homepage = "https://github.com/SlimeVR/SlimeVR-Server";
  };
}

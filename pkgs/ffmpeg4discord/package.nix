{
  lib,
  inputs,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "ffmpeg4discord";
  version = inputs.ffmpeg4discord.shortRev;
  src = inputs.ffmpeg4discord.outPath;
  format = "pyproject";

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    flask
    ffmpeg-python
    platformdirs
  ];

  patches = [ ./fps-mode.patch ];

  pythonRelaxDeps = [ "flask" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "Target File Size Video Compression for Discord with FFmpeg";
    homepage = "https://github.com/zfleeman/ffmpeg4discord";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ different-name ];
  };
}

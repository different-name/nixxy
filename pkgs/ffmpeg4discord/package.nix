{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "ffmpeg4discord";
  version = "0.1.9";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6JUKnsqQRMh2tIgAHho7IAFBO3scE22QNy8zVVxaOXo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    flask
    ffmpeg-python
  ];

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

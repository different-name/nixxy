{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonPackage {
  pname = "tinyoscquery";
  version = "0.1.2-unstable-2024-07-07";
  pyproject = true;

  # oscleash depends on this fork
  src = fetchFromGitHub {
    owner = "Hackebein";
    repo = "tinyoscquery";
    rev = "a2c0af468e457f106cd71a5c6fd348ae5ea5d665";
    hash = "sha256-psckZ32ZEQ1+Ez6U60pGLqqroWWZAkNq2bs8JIA1wqo=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
    zeroconf
  ];

  pythonImportsCheck = [ "tinyoscquery" ];

  meta = {
    description = "Quick and dirty python implementation for OSCQuery";
    homepage = "https://github.com/Hackebein/tinyoscquery";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ different-name ];
    platforms = lib.platforms.all;
  };
}

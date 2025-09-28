# credit to https://github.com/xantoz/nixconfig/blob/8819bee32a056c3d1edaded8dcdae6b4ce6c0ab4/overlays/local/pkgs/XR/FT/EyeTrackVR/default.nix#L107
{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,

  # cmake,

  # onnxruntime,
  # opencv4,
  eigen,
}:

let
  pypkgs = python3Packages;

  # TODO: Dedup with ProjectBabble
  FreeSimpleGUI = pypkgs.buildPythonPackage rec {
    pname = "freesimplegui";
    version = "5.2.0";

    pyproject = true;
    build-system = with pypkgs; [
      setuptools
      wheel
    ];

    dependencies = with pypkgs; [ tkinter ];
    propagatedBuildInputs = with pypkgs; [ tkinter ];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-UMhpuNXYT0gXUmCiFp5Cc5T/GyKxCbUUGFjV9Q5jvvo=";
    };
  };

  # TODO: Dedup with ProjectBabble
  python_osc = pypkgs.buildPythonPackage rec {
    pname = "python_osc";
    version = "1.9.0";

    pyproject = true;
    build-system = with pypkgs; [
      setuptools
      wheel
    ];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-q1D2axoZ79W/9yLyarZFDfGc3YS6ho8IyaM+fHhRRFY=";
    };
  };

  pye3d = pypkgs.buildPythonPackage rec {
    pyproject = true;

    pname = "pye3d";
    version = "0.3.2";

    build-system = [
      pypkgs.ninja
      pypkgs.cmake
      pypkgs.scikit-build
      pypkgs.setuptools-scm
      pypkgs.cython
    ];

    # We need this to stop cmakeConfigurePhase from coming in and ruining things for us
    dontUseCmakeConfigure = true;

    buildInputs = [
      eigen
      # opencv4
    ];

    dependencies = [
      # pypkgs.opencv4
      pypkgs.opencv-python
      pypkgs.numpy
      pypkgs.msgpack
      pypkgs.msgpack-numpy
      pypkgs.sortedcontainers
    ];

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-Enk90LKSZTklLWsrqd9rDBd0lHoAdmGywWcO9zyQUzk=";
    };
  };
in
pypkgs.buildPythonApplication rec {
  pyproject = true;
  build-system = with pypkgs; [
    poetry-core
    # pyinstaller
    # taskipy would probably go here if we wanted to run the tests
    setuptools
    wheel
  ];

  # We are lazy and don't do checking.
  # (although actually it seems like we aren't automatically attempting the taskipy checks even if this is true)
  doCheck = false;

  # We are using too new versions of some libraries according to pyproject.toml
  pythonRelaxDeps = true;
  pythonRemoveDeps = [
    "pysimplegui-4-foss" # since naming changed to FreeSimpleGUI we have to remove this
    "taskipy" # taskipy is only needed for testing.
  ];

  pname = "EyeTrackVR";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "EyeTrackVR";
    repo = "EyeTrackVR";
    rev = "EyeTrackApp-${version}";
    hash = "sha256-KAjyhiTf+UP94f4+cNZX3EiFaHyxtNjIjDX2359BE6s=";
  };

  dependencies = [
    python_osc
    pypkgs.requests
    pypkgs.opencv4
    pypkgs.opencv-python
    pypkgs.numpy
    pye3d
    FreeSimpleGUI
    pypkgs.pydantic
    pypkgs.scikit-image
    pypkgs.pyserial
    # winotify (windows only)
    pypkgs.onnxruntime
    pypkgs.colorama
    pypkgs.pytest
    pypkgs.pytest-cov
    pypkgs.psutil
    pypkgs.numba
  ];

  postPatch = ''
    # Patching to work with newer FreeSimpleGUI version (module name changed)
    find EyeTrackApp/ -iregex '.*\.\(py\|spec\)$' -exec sed -i 's/PySimpleGUI/FreeSimpleGUI/' {} +

    # Patching to store settings in XDG compliant manner
    sed -i -e '1 i\from pathlib import Path' \
           -e 's|^CONFIG_FILE_NAME.*$|CONFIG_FILE_NAME = Path.home() / ".config" / "EyeTrackVR" / "eyetrack_settings.json"|' \
           -e '/^CONFIG_FILE_NAME.*$/a CONFIG_FILE_NAME.parent.mkdir(parents=True, exist_ok=True)' \
           -e 's|^BACKUP_CONFIG_FILE_NAME.*$|BACKUP_CONFIG_FILE_NAME = Path.home() \/ ".config" \/ "EyeTrackVR" \/ "eyetrack_settings.backup"|' \
           -e '/^BACKUP_CONFIG_FILE_NAME.*$/a BACKUP_CONFIG_FILE_NAME.parent.mkdir(parents=True, exist_ok=True)' \
           EyeTrackApp/config.py

    # Do an ugly sys.path hack, because imports are all wrong
    # Also contains an ugly chdir hack, because of all the relative paths in babble
    echo -e 'import sys\nimport os\nfrom pathlib import Path\nmypath = str(Path(__file__).resolve().parent)\nsys.path.append(mypath)\nprint(sys.path)\nos.chdir(mypath)\n' > EyeTrackApp/__init__.py

    # Add an entrypoint to pyproject.toml (As we do not use pyinstaller to create a bundled executable)
    # We need to add the name and version here too, since the part where it's under tool.poetry is outdated...
    echo '

    [project]
    name = "EyeTrackVR"
    version = "${version}"

    [project.scripts]
    "eyetrack-app" = "eyetrackvr.eyetrackapp:main"
    ' >> pyproject.toml

    echo "=======pyproject.toml======="
    cat pyproject.toml
    echo "=======END======="


    # # Replace the original pyproject.toml
    # echo '
    # [project]
    # name = "EyeTrackVR"
    # version = "${version}"
    #
    # [project.scripts]
    # "eyetrack-app" = "eyetrackvr.eyetrackapp:main"
    # ' > pyproject.toml

    # Ugly hack to get poetry to find the module
    mv EyeTrackApp eyetrackvr
  '';

  meta = {
    description = "Source First and *affordable* VR eye tracker platform for VRCHat via `OSC` and `UDP` protocol.";
    homepage = "https://github.com/EyeTrackVR/EyeTrackVR.git";
    license = lib.licenses.unfreeRedistributable // {
      url = "https://github.com/${src.owner}/${src.repo}/blob/${src.rev}/LICENSE";
    };
    mainProgram = "eyetrack-app";
  };
}

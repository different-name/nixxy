{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  ncurses,
  python3,
  tinyoscquery,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "oscleash";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "ZenithVal";
    repo = "OSCLeash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X1UZ4IwrSLYI8IbdzaikjKQbSDRQCou0n6XYs2XS2sQ=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # tag ships the previous release's version string
  postPatch = ''
    substituteInPlace OSCLeash.py \
      --replace-fail '"v"+"2.2.0"' '"v${finalAttrs.version}"'
  '';

  installPhase =
    let
      pythonEnv = python3.withPackages (ps: [
        ps.python-osc
        tinyoscquery
      ]);
    in
    ''
      runHook preInstall

      mkdir -p $out/share/oscleash
      cp -r Controllers OSCLeash.py $out/share/oscleash/

      # ncurses for the clear it runs on startup
      makeWrapper ${pythonEnv}/bin/python3 $out/bin/oscleash \
        --add-flags $out/share/oscleash/OSCLeash.py \
        --prefix PATH : ${lib.makeBinPath [ ncurses ]}

      runHook postInstall
    '';

  meta = {
    description = "OSC tool to move a VRChat player in the direction of a stretched physbone";
    homepage = "https://github.com/ZenithVal/OSCLeash";
    license = lib.licenses.mit;
    mainProgram = "oscleash";
    maintainers = with lib.maintainers; [ different-name ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-obsidian-theme";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "obsidian";
    rev = version;
    hash = "sha256-9fSFj9Tzc2aN9zpG5CyDMngVcwYEppf7MF1ZPUWFyz4=";
  };

  installPhase = ''
    mkdir -p $out
    cp -r $src/. $out/
  '';

  meta = {
    description = "Soothing pastel theme for Obsidian";
    homepage = "https://github.com/catppuccin/obsidian";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ different-name ];
    mainProgram = "catppuccin-obsidian-theme";
    platforms = lib.platforms.all;
  };
}

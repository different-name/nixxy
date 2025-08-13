{
  sources,
  lib,
  stdenvNoCC,
  build-stylus-settings,
  userstylesConfig ? { },
  ...
}:
let
  userstylesOptionsFile = builtins.toFile "catppuccin-userstyles-options" (
    builtins.toJSON userstylesConfig
  );
in
stdenvNoCC.mkDerivation {
  inherit (sources.catppuccin-userstyles) pname version src;
  port = "userstyles";

  nativeBuildInputs = [
    build-stylus-settings
  ];

  buildPhase = ''
    build-stylus-settings "$src/styles" "${userstylesOptionsFile}"
    mkdir -p $out/share
    cp storage.js $out/share/
  '';

  meta = {
    description = "Soothing pastel theme for userstyles";
    homepage = "https://github.com/catppuccin/userstyles";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ different-name ];
    platforms = lib.platforms.all;
  };
}

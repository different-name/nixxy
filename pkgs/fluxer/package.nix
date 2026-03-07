{
  lib,
  appimageTools,
  fetchurl,
}:
let
  version = "0.0.8";
  mainProgram = "fluxer";
in
appimageTools.wrapType2 {
  pname = "fluxer";
  inherit version;

  src = fetchurl {
    url = "https://api.fluxer.app/dl/desktop/stable/linux/x64/${version}/appimage";
    hash = "sha256-GdoBK+Z/d2quEIY8INM4IQy5tzzIBBM+3CgJXQn0qAw=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cat > $out/share/applications/fluxer.desktop <<'EOF'
    [Desktop Entry]
    Name=Fluxer
    Exec=${mainProgram}
    Type=Application
    Categories=Network;
    Terminal=false
    EOF
  '';

  meta = {
    description = "A free and open source instant messaging and VoIP platform";
    homepage = "https://github.com/fluxerapp/fluxer";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    inherit mainProgram;
  };
}

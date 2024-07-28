{
  lib,
  appimageTools,
  fetchurl,
  zulu,
}: let
  pname = "slimevr";
  version = "0.12.1";

  src = fetchurl {
    url = "https://github.com/SlimeVR/SlimeVR-Server/releases/download/v${version}/SlimeVR-amd64.appimage";
    hash = "sha256-AyXL1oVmbEmGbAXQT4cWKvAHM+fkK2DfMSrizwuYRbU=";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs:
      with pkgs; [
        jre17_minimal
      ];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/slimevr.desktop -t $out/share/applications
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    # meta = with lib; {
    #   description = "Server app for SlimeVR ecosystem";
    #   homepage = "https://github.com/SlimeVR/SlimeVR-Server";
    #   changelog = "https://github.com/SlimeVR/SlimeVR-Server/releases/tag/v${version}";
    #   license = licenses.mit;
    #   mainProgram = "slimevr";
    #   maintainers = with maintainers; [ different ];
    #   platforms = [ "x86_64-linux" ];
    # };
  }

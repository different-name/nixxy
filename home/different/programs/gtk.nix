{ config, pkgs, lib, ... }:
let
  gradiencePreset = pkgs.fetchurl { url = "https://raw.githubusercontent.com/GradienceTeam/Community/next/official/catppuccin-macchiato.json"; hash = "sha256-FgQvmK/Pjn980o+UVc2a70kGa6sGse045zPS9hzCs14="; };
  gradienceBuild = pkgs.stdenv.mkDerivation {
    name = "gradience-build";
    phases = [ "buildPhase" "installPhase" ];
    nativeBuildInputs = [ pkgs.gradience ];
    buildPhase = ''
      shopt -s nullglob
      export HOME=$TMPDIR
      mkdir -p $HOME/.config/presets
      gradience-cli apply -p ${gradiencePreset} --gtk both
    '';
    installPhase = ''
      mkdir -p $out
      cp -r .config/gtk-4.0 $out/
      cp -r .config/gtk-3.0 $out/
    '';
  };
in
{
  gtk = {
    enable = true;

    gtk3 = {
      extraCss = builtins.readFile "${gradienceBuild}/gtk-3.0/gtk.css";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      extraCss = builtins.readFile "${gradienceBuild}/gtk-4.0/gtk.css";
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };
}
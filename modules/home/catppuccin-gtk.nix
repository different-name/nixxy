# the upstream catppuccin/nix gtk module was removed, but the theme itself is still fine
# see https://github.com/catppuccin/nix/pull/644
{
  lib,
  config,
  options,
  inputs,
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mkIf
    mkOption
    types
    ;

  catppuccinLib = import (inputs.catppuccin + /modules/lib) {
    inherit
      lib
      config
      options
      pkgs
      ;
  };

  cfg = config.catppuccin-workarounds.gtk;
  enable = cfg.enable && config.gtk.enable;

  themeName =
    "catppuccin-${cfg.flavor}-${cfg.accent}-${cfg.size}+"
    + (if cfg.tweaks == [ ] then "default" else concatStringsSep "," cfg.tweaks);

  themePackage = pkgs.stdenvNoCC.mkDerivation {
    pname = "catppuccin-gtk-theme";
    version = "1.0.3";

    src = pkgs.fetchzip {
      url = "https://github.com/catppuccin/gtk/releases/download/v${themePackage.version}/${themeName}.zip";
      # hash is specific to a flavor/accent/size/tweaks combination
      # low maintenance, don't need to maintain deprecated derivation to build from source
      hash = "sha256-X06sMVPenEtmpYNi8dWQiLj/n/nRUT9OzEEvTwoxyAA=";
      stripRoot = false;
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes
      cp -r "${themeName}" "$out/share/themes/"
      runHook postInstall
    '';

    meta = {
      description = "Soothing pastel theme for GTK";
      homepage = "https://github.com/catppuccin/gtk";
      license = lib.licenses.gpl3Plus;
    };
  };
in
{
  options.catppuccin-workarounds.gtk =
    catppuccinLib.mkCatppuccinOption {
      name = "gtk";

      accentSupport = true;
    }
    // {
      size = mkOption {
        type = types.enum [
          "standard"
          "compact"
        ];
        default = "standard";
        description = "Catppuccin size variant for gtk";
      };

      tweaks = mkOption {
        type = types.listOf (
          types.enum [
            "black"
            "rimless"
            "normal"
            "float"
          ]
        );
        default = [ ];
        description = "Catppuccin tweaks for gtk";
      };
    };

  config = mkIf enable {
    gtk.theme = {
      name = themeName;
      package = themePackage;
    };

    xdg.configFile =
      let
        gtk4Dir = "${themePackage}/share/themes/${themeName}/gtk-4.0";
      in
      {
        "gtk-4.0/assets".source = "${gtk4Dir}/assets";
        "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
        "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
      };
  };
}

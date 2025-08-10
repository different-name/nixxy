# workaround for https://github.com/catppuccin/nix/pull/644
# based on https://github.com/Weathercold/nixfiles/blob/b562942e0dba0fa8595b4cb0ca5aef7f65262033/home/modules/themes/catppuccin/gtk.nix
{
  lib,
  config,
  self,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkIf
    mkDefault
    concatStringsSep
    toSentenceCase
    optional
    ;
  inherit (config.catppuccin) sources;

  cfg = config.catppuccin.gtk.magnetic;

  catppuccinLib = import (self.inputs.catppuccin + /modules/lib) { inherit lib config pkgs; };

  shade = if cfg.flavor == "latte" then "light" else "dark";
  flavorTweak = if cfg.flavor == "frappe" || cfg.flavor == "macchiato" then cfg.flavor else null;
in
{
  options.catppuccin.gtk.magnetic =
    catppuccinLib.mkCatppuccinOption {
      name = "gtk";
    }
    // {
      accent = mkOption {
        type = types.enum [
          "default"
          "purple"
          "pink"
          "red"
          "orange"
          "yellow"
          "green"
          "teal"
          "grey"
          "all"
        ];
        default = "default";
      };

      size = mkOption {
        type = types.enum [
          "standard"
          "compact"
        ];
        default = "standard";
      };

      tweaks = mkOption {
        type =
          with types;
          listOf (enum [
            "black"
            "float"
            "outline"
            "macos"
          ]);
        default = [ ];
      };
    };

  config = mkIf cfg.enable {
    gtk.theme = {
      name = concatStringsSep "-" (
        [ "Catppuccin-GTK" ]
        ++ map toSentenceCase (
          optional (cfg.accent != "default") cfg.accent
          ++ [ shade ]
          ++ optional (cfg.size != "standard") cfg.size
          ++ optional (flavorTweak != null) flavorTweak
        )
      );

      package = sources.magnetic-gtk.override {
        accent = [ cfg.accent ];
        inherit shade;
        inherit (cfg) size;
        tweaks = cfg.tweaks ++ optional (flavorTweak != null) flavorTweak;
      };
    };

    catppuccin.sources.magnetic-gtk = mkDefault pkgs.magnetic-catppuccin-gtk;
  };
}

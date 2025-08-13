# workaround for https://github.com/catppuccin/nix/pull/644
{
  lib,
  config,
  inputs,
  inputs',
  pkgs,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mkIf
    mkMerge
    mkOption
    types
    ;

  catppuccinLib = import (inputs.catppuccin + /modules/lib) { inherit lib config pkgs; };

  cfg = config.catppuccin-workarounds.gtk;
  enable = cfg.enable && config.gtk.enable;
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

  config = mkMerge [
    (mkIf enable {
      gtk.theme =
        let
          gtkTweaks = concatStringsSep "," cfg.tweaks;
        in
        {
          name =
            "catppuccin-${cfg.flavor}-${cfg.accent}-${cfg.size}+"
            + (if (cfg.tweaks == [ ]) then "default" else gtkTweaks);
          package = config.catppuccin.sources.gtk.override {
            inherit (cfg) flavor size tweaks;
            accents = [ cfg.accent ];
          };
        };

      xdg.configFile =
        let
          gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
        in
        {
          "gtk-4.0/assets".source = "${gtk4Dir}/assets";
          "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
          "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
        };
    })

    {
      catppuccin.sources.gtk = inputs'.catppuccin-gtk.packages.gtk;
    }
  ];
}

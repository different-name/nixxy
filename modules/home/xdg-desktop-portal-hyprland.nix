{ lib, config, ... }:
let
  inherit (lib) types;

  cfg = config.wayland.windowManager.hyprland.xdgDesktopPortalHyprland;

  valueToString = value: if builtins.isBool value then lib.boolToString value else toString value;

  generateBlock = name: attrs: ''
    ${name} {
      ${lib.concatMapAttrsStringSep "\n  " (k: v: "${k} = ${valueToString v}") attrs}
    }
  '';

  generateConfig = settings: lib.concatMapAttrsStringSep "\n\n" generateBlock settings;
in
{
  options.wayland.windowManager.hyprland.xdgDesktopPortalHyprland = {
    settings = lib.mkOption {
      type = types.attrsOf (
        types.attrsOf (
          types.oneOf [
            types.bool
            types.int
            types.str
          ]
        )
      );
      default = { };
      description = "Configuration for xdg-desktop-portal-hyprland https://wiki.hyprland.org/Hypr-Ecosystem/xdg-desktop-portal-hyprland/#configuration";
      example = {
        screencopy = {
          allow_token_by_default = true;
        };
        input = {
          kb_layout = "us";
        };
      };
    };
  };

  config = lib.mkIf (config.wayland.windowManager.hyprland.enable && cfg.settings != { }) {
    xdg.configFile."hypr/xdph.conf".text = generateConfig cfg.settings;
  };
}

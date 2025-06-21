{
  lib,
  config,
  pkgs,
  ...
}:
let
  hyprlandCfg = config.wayland.windowManager.hyprland;
  borderColor = "ed507c";
in
{
  options.nix-files.parts.desktop.mako.enable = lib.mkEnableOption "mako config";

  config = lib.mkIf config.nix-files.parts.desktop.mako.enable {
    services.mako = {
      enable = true;
      settings = {
        "border-color" = lib.mkForce "#${borderColor}";
        "border-radius" = hyprlandCfg.settings.decoration.rounding;

        "mode=do-not-disturb" = {
          invisible = 1;
        };
      };
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "mako-dnd";
        runtimeInputs = lib.attrValues {
          inherit (pkgs) hyprland mako;
        };

        text = ''
          if makoctl mode | grep -q '\<do-not-disturb\>'; then
              makoctl mode -r do-not-disturb
              hyprctl notify -1 5000 "rgb(${borderColor})" "Notifications Shown"
          else
              makoctl mode -a do-not-disturb
              hyprctl notify -1 5000 "rgb(${borderColor})" "Notifications Hidden"
          fi
        '';
      })
    ];
  };
}

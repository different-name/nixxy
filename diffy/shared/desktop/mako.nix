{
  bundleLib,
  config,
  lib,
  ...
}:
let
  inherit (config.dyad.desktop.hyprland) rounding;
  withHyprland = config.dyad.desktop.hyprland.enable;
in
bundleLib.mkEnableModule [ "dyad" "desktop" "mako" ] {
  dyad.desktop.swayosd.enable = true;

  home-manager =
    { config, pkgs, ... }:
    let
      inherit (config.dyad) palette;
    in
    {
      # catppuccin's include sorts after the settings and would override the translucent background
      catppuccin.mako.enable = false;

      services.mako = {
        enable = true;
        settings = {
          "background-color" = "${palette.base.hex}d9";
          "border-color" = palette.${config.catppuccin.accent}.hex;
          "border-radius" = rounding;
          "progress-color" = "over ${palette.surface0.hex}";
          "text-color" = palette.text.hex;

          "mode=hide-chat app-name=Signal" = {
            invisible = 1;
          };

          "mode=hide-chat app-name=discord" = {
            invisible = 1;
          };

          "mode=do-not-disturb" = {
            invisible = 1;
          };

          "urgency=high" = {
            "border-color" = palette.peach.hex;
          };
        };
      };

      wayland.windowManager.hyprland.settings.layer_rule = lib.mkIf withHyprland (
        lib.singleton {
          name = "mako";
          match.namespace = "^notifications$";
          blur = true;
          ignore_alpha = 0.5;
        }
      );

      # bound in hyprland
      home.packages = lib.singleton (
        pkgs.writeShellApplication {
          name = "mako-dnd";

          runtimeInputs = [
            config.services.mako.package
            pkgs.gnugrep
            pkgs.swayosd
          ];

          text = ''
            osd() {
                swayosd-client --custom-icon "$1" --custom-message "$2"
            }

            modes=$(makoctl mode)
            if grep -qx do-not-disturb <<<"$modes"; then
                makoctl mode -r do-not-disturb
                osd notifications-symbolic "Notifications Shown"
            elif grep -qx hide-chat <<<"$modes"; then
                makoctl mode -r hide-chat -a do-not-disturb
                osd notifications-disabled-symbolic "All Notifications Hidden"
            else
                makoctl mode -a hide-chat
                osd notification-inactive-symbolic "Chat Notifications Hidden"
            fi
          '';
        }
      );
    };
}

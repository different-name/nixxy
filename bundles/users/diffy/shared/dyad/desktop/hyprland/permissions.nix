{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    home-manager =
      { pkgs, ... }:
      {
        wayland.windowManager.hyprland.settings = {
          ecosystem.enforce_permissions = true;

          permission = map (path: "${lib.escapeRegex path}, screencopy, allow") [
            (lib.getExe pkgs.grimblast)
            (pkgs.xdg-desktop-portal-hyprland + /libexec/.xdg-desktop-portal-hyprland-wrapped)
          ];
        };
      };
  };
}

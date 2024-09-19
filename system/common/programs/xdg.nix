{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.programs.xdg.enable = lib.mkEnableOption "xdg config";

  config = lib.mkIf config.nix-files.programs.xdg.enable {
    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config = {
          common.default = ["gtk"];
          hyprland.default = ["gtk" "hyprland"];
        };

        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };
    };
  };
}

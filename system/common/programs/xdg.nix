{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.programs.xdg.enable = lib.mkEnableOption "xdg config";

  config = lib.mkIf config.nix-files.programs.xdg.enable {
    # credit https://github.com/fufexan/dotfiles/blob/5f26e650e3b5ab6c116b8a0e2671f568f79d77d7/system/programs/xdg.nix
    xdg.portal = {
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
}

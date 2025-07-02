{ lib, config, ... }:
let
  catppuccinPalette = lib.importJSON "${config.catppuccin.sources.palette}/palette.json";
  themeColors = catppuccinPalette.${config.catppuccin.flavor}.colors;
  accentColor = themeColors.${config.catppuccin.accent}.hex;
in
{
  options.nix-files.parts.terminal.fastfetch.enable = lib.mkEnableOption "fastfetch config";

  config = lib.mkIf config.nix-files.parts.terminal.fastfetch.enable {
    programs.fastfetch = {
      enable = true;

      settings = {
        logo.type = "none";

        display = {
          separator = ": ";
          color = {
            title = accentColor;
            separator = "dim_white";
            keys = accentColor;
          };
        };

        modules = [
          "Title"
          "Separator"
          "OS"
          "Kernel"
          (
            if config.wayland.windowManager.hyprland.enable then
              {
                key = "Compositor";
                type = "WM";
              }
            else
              "Shell"
          )
          "Terminal"
          "Bios"
          "InitSystem"
        ];
      };
    };

    nix-files.parts.system.persistence = {
      directories = [
        ".cache/fastfetch"
      ];
    };
  };
}

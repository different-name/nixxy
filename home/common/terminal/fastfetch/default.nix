{
  lib,
  config,
  ...
}: {
  options.nix-files.terminal.fastfetch.enable = lib.mkEnableOption "Fastfetch config";

  config = lib.mkIf config.nix-files.terminal.fastfetch.enable {
    programs.fastfetch = {
      enable = true;

      settings = {
        logo = {
          type = "kitty-direct";
          source = ./fastfetch.png;
          width = 18;
          height = 8;
          padding = {
            left = 0;
            right = 2;
          };
        };

        display = {
          separator = ": ";
          color = {
            title = "red";
            separator = "dim_white";
            keys = "red";
          };
        };

        modules = [
          "Title"
          "Separator"
          "OS"
          "Kernel"
          (
            if config.wayland.windowManager.hyprland.enable
            then {
              key = "Compositor";
              type = "WM";
            }
            else "Shell"
          )
          "Terminal"
          "Bios"
          "InitSystem"
        ];
      };
    };

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/fastfetch"
      ];
    };
  };
}

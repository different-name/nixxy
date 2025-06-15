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
        logo.type = "none";

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

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/fastfetch"
      ];
    };
  };
}

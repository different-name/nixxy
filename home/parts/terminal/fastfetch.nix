{
  lib,
  config,
  ...
}:
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

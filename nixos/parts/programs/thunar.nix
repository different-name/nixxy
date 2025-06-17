{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nix-files.parts.programs.thunar.enable = lib.mkEnableOption "Thunar config";

  config = lib.mkIf config.nix-files.parts.programs.thunar.enable {
    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
      ];
    };

    # mount, trash, and other functionalities
    services.gvfs.enable = true;

    # thumbnail support for images
    services.tumbler.enable = true;

    # archive support
    programs.file-roller.enable = true;
  };
}

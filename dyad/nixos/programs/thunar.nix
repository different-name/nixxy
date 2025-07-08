{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.programs.thunar.enable = lib.mkEnableOption "thunar config";

  config = lib.mkIf config.dyad.programs.thunar.enable {
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

    home-manager.sharedModules = [
      {
        xdg.mimeApps.defaultApplications = {
          "inode/directory" = lib.mkDefault "thunar.desktop";
        };
      }
    ];

    environment.persistence-wrapper.home = {
      dirs = [
        # keep-sorted start
        ".config/Thunar"
        ".local/share/gvfs-metadata" # gnome virtual file system data / cache
        # keep-sorted end
      ];

      files = [
        ".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
      ];
    };
  };
}

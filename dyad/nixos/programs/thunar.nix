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
      plugins = [
        pkgs.thunar-archive-plugin
      ];
    };

    # mount, trash, and other functionalities
    services.gvfs.enable = true;

    # thumbnail support for images
    services.tumbler.enable = true;

    environment.systemPackages = [
      # archive support
      pkgs.file-roller
    ];

    home-manager.sharedModules = lib.singleton {
      xdg.mimeApps.defaultApplications = {
        "inode/directory" = lib.mkDefault "thunar.desktop";
      };

      home.perpetual.default = {
        dirs = [
          "$configHome/Thunar"
          "$dataHome/gvfs-metadata" # gnome virtual file system data / cache
        ];
        files = [
          "$configHome/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
        ];
      };
    };
  };
}

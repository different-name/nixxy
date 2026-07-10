{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "thunar" ] {
  nixos = { pkgs, ... }: {
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
  };

  home-manager = {
    xdg.mimeApps.defaultApplications = {
      "inode/directory" = lib.mkDefault "thunar.desktop";
    };

    home.perpetual.default.dirs = [
      "$configHome/Thunar"
      "$configHome/xfce4"
      "$dataHome/gvfs-metadata" # gnome virtual file system data / cache
    ];
  };
}

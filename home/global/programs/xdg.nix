{
  xdg = {
    enable = true;

    mime.enable = true;

    desktopEntries = {
      imv = {
        name = "imv";
        comment = "Image Viewer";
        exec = "imv %U";
        icon = "imv";
        terminal = false;
        type = "Application";
        categories = ["Graphics"];
      };
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # directories
        "inode/directory" = "thunar.desktop";

        # images
        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/tiff" = "imv.desktop";
        "image/x-icon" = "imv.desktop";

        # unity login
        "x-scheme-handler/unityhub" = "unityhub.desktop";
      };
    };
  };
}

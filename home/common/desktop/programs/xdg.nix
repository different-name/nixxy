{
  xdg = {
    enable = true;
    mime.enable = true;

    desktopEntries = {
      imv-dir = {
        name = "imv-dir";
        comment = "Image Viewer";
        exec = "imv-dir %U";
        icon = "imv-dir";
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
        "image/png" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "image/gif" = "imv-dir.desktop";
        "image/bmp" = "imv-dir.desktop";
        "image/tiff" = "imv-dir.desktop";
        "image/x-icon" = "imv-dir.desktop";

        # text
        "text/plain" = "codium.desktop";
        "application/json" = "codium.desktop";
        "text/markdown" = "codium.desktop";

        # unity login
        "x-scheme-handler/unityhub" = "unityhub.desktop";
      };
    };
  };
}

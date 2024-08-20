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
      
      steam = {
        name = "Steam";
        comment = "Application for managing and playing games on Steam";
        exec = "steam %U -forcedesktopscaling 1.5";
        icon = "steam";
        terminal = false;
        type = "Application";
        categories = ["Network" "FileTransfer" "Game"];
        mimeTypes = ["x-scheme-handler/steam" "x-scheme-handler/steamlink"];
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

        # unity login
        "x-scheme-handler/unityhub" = "unityhub.desktop";
      };
    };
  };
}

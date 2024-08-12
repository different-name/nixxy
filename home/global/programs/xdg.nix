{
  xdg = {
    enable = true;

    mime.enable = true;

    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "thunar.desktop";
        "x-scheme-handler/unityhub" = "unityhub.desktop";
      };
    };
  };
}

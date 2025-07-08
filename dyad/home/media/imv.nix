{ lib, config, ... }:
{
  options.dyad.media.imv.enable = lib.mkEnableOption "imv config";

  config = lib.mkIf config.dyad.media.imv.enable {
    programs.imv.enable = true;

    xdg = {
      desktopEntries = {
        imv-dir = {
          name = "imv-dir";
          comment = "Image Viewer";
          exec = "imv-dir %U";
          icon = "imv-dir";
          terminal = false;
          type = "Application";
          categories = [ "Graphics" ];
        };
      };

      mimeApps.defaultApplications = {
        # keep-sorted start
        "image/bmp" = "imv-dir.desktop";
        "image/gif" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "image/png" = "imv-dir.desktop";
        "image/tiff" = "imv-dir.desktop";
        "image/x-icon" = "imv-dir.desktop";
        # keep-sorted end
      };
    };
  };
}

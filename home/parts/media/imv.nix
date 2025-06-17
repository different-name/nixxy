{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.media.imv.enable = lib.mkEnableOption "imv config";

  config = lib.mkIf config.nix-files.parts.media.imv.enable {
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
        "image/png" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "image/gif" = "imv-dir.desktop";
        "image/bmp" = "imv-dir.desktop";
        "image/tiff" = "imv-dir.desktop";
        "image/x-icon" = "imv-dir.desktop";
      };
    };
  };
}

{ lib, config, ... }:
{
  options.dyad.desktop.xdg.enable = lib.mkEnableOption "xdg config";

  config = lib.mkIf config.dyad.desktop.xdg.enable {
    xdg = {
      enable = true;
      autostart.enable = true;
      mime.enable = true;

      mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = "thunar.desktop"; # directories
          "x-scheme-handler/unityhub" = "unityhub.desktop"; # unity login
        };
      };

      configFile."mimeapps.list".force = true;
    };
  };
}

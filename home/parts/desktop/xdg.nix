{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.desktop.xdg.enable = lib.mkEnableOption "XDG config";

  config = lib.mkIf config.nix-files.parts.desktop.xdg.enable {
    xdg = {
      enable = true;
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

{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.meta.xdg.enable = lib.mkEnableOption "XDG config";

  config = lib.mkIf config.nix-files.graphical.meta.xdg.enable {
    xdg = {
      enable = true;
      mime.enable = true;

      mimeApps = {
        enable = true;
        defaultApplications = {
          # directories
          "inode/directory" = "thunar.desktop";

          # unity login
          "x-scheme-handler/unityhub" = "unityhub.desktop";
        };
      };
    };
  };
}

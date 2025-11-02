{ lib, config, ... }:
{
  options.dyad.applications.firefox.enable = lib.mkEnableOption "firefox config";

  config = lib.mkIf config.dyad.applications.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "firefox.desktop";
    };

    home.perpetual.default.dirs = [
      "$cacheHome/mozilla/firefox"
      ".mozilla/firefox"
    ];
  };
}

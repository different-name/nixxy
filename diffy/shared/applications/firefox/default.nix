{ bundleLib, inputs, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "firefox" ] {
  home-manager = {
    imports = [ inputs.betterfox.homeModules.betterfox ];

    programs.firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
      };

      betterfox = {
        enable = true;
        profiles.default.enableAllSections = true;
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "firefox.desktop";
    };

    home.perpetual.default.dirs = [
      "$cacheHome/mozilla/firefox"
      "$configHome/mozilla/firefox"
    ];
  };
}

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
      # keep-sorted start
      "application/pdf" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      # keep-sorted end
    };

    home.perpetual.default.dirs = [
      "$cacheHome/mozilla/firefox"
      "$configHome/mozilla/firefox"
    ];
  };
}

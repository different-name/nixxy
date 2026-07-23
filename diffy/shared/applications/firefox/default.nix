{
  bundleLib,
  inputs,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "firefox" ] {
  home-manager = { config, ... }: {
    imports = [ inputs.betterfox.homeModules.betterfox ];

    age.secrets."firefox/bookmarks".file = self + /secrets/firefox/bookmarks.age;

    programs.firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;

        settings = {
          "browser.bookmarks.file" = config.age.secrets."firefox/bookmarks".path;
          "browser.places.importBookmarksHTML" = true;
        };
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

{
  bundleLib,
  inputs,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "firefox" ] {
  # bookmarks are managed through an encrypted policies file
  # because i don't feel like sharing my bookmarks with the world
  nixos.age.secrets.firefox-policies = {
    file = self + /diffy/secrets/firefox/policies.age;
    path = "/etc/firefox/policies/policies.json";
    mode = "0444";
  };

  home-manager = {
    imports = [ inputs.betterfox.homeModules.betterfox ];

    programs.firefox = {
      enable = true;

      profiles.default = {
        id = 0;
        name = "default";
        isDefault = true;
      };

      # profile for ytdlp cookies, closing after login prevents cookie rotation
      profiles.ytdlp = {
        id = 1;
        name = "ytdlp";
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

    keep.safe = {
      cacheDirs = [ "mozilla/firefox" ];
      configDirs = [ "mozilla/firefox" ];
    };

    # apps register their extension hosts again at runtime
    programs.keep.exclude = [ ".config/mozilla/native-messaging-hosts" ];
  };
}

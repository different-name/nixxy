{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.librewolf.enable {
    programs.librewolf.profiles.default.settings = {
      ### preferences

      # disable pocket
      "extensions.pocket.enabled" = false;

      # disable about:config warning
      "browser.aboutConfig.showWarning" = false;

      # force dark style
      "layout.css.prefers-color-scheme.content-override" = 0;

      # search engine
      "browser.newtabpage.activity-stream.trendingSearch.defaultSearchEngine" =
        config.programs.librewolf.profiles.default.search.default;

      ### anti privacy stuff

      # breaks dark mode when enabled
      "privacy.resistFingerprinting" = false;

      # don't clear these on shutdown
      "privacy.clearOnShutdown.cache" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.clearOnShutdown_v2.cache" = false;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.clearOnShutdown_v2.formdata" = false;
    };
  };
}

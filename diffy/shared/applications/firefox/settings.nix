{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.firefox.enable {
    home-manager = { config, ... }: {
      programs.firefox.profiles.default.settings = {
        ### preferences

        # # disable pocket
        # "extensions.pocket.enabled" = false;

        # # disable about:config warning
        # "browser.aboutConfig.showWarning" = false;

        # # force dark style
        # "layout.css.prefers-color-scheme.content-override" = 0;

        # search engine
        "browser.newtabpage.activity-stream.trendingSearch.defaultSearchEngine" =
          config.programs.firefox.profiles.default.search.default;

        # ### privacy stuff

        # # prevent websites from probing local network
        # "network.lna.blocking" = true;
        # "network.lna.local-network-to-localhost.skip-checks" = false;
        # "network.lna.websocket.enabled" = true;

        # ### anti privacy stuff

        # # breaks dark mode when enabled
        # "privacy.resistFingerprinting" = false;

        # # don't clear these on shutdown
        # "privacy.clearOnShutdown.cache" = false;
        # "privacy.clearOnShutdown.cookies" = false;
        # "privacy.clearOnShutdown.history" = false;
        # "privacy.clearOnShutdown.sessions" = false;
        # "privacy.clearOnShutdown_v2.cache" = false;
        # "privacy.clearOnShutdown_v2.cookies`AndStorage" = false;
        # "privacy.clearOnShutdown_v2.formdata" = false;
      };
    };
  };
}

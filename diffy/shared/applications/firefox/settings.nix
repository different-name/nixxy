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

        ### password manager & form saving

        # disable the built-in password manager
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.generation.enabled" = false;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.firefoxRelay.feature" = "disabled";

        # don't save form/search history
        "browser.formfill.enable" = false;

        # disable address & credit card autofill
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;

        ### address bar autocomplete & suggestions
        # keep only bookmarks and currently open tabs

        "browser.urlbar.suggest.bookmark" = true;
        "browser.urlbar.suggest.openpage" = true;

        # disable everything else
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.recentsearches" = false;
        "browser.urlbar.suggest.trending" = false;
        "browser.urlbar.suggest.weather" = false;
        "browser.urlbar.suggest.clipboard" = false;
        "browser.urlbar.suggest.calculator" = false;
        "browser.urlbar.suggest.addons" = false;
        "browser.urlbar.suggest.mdn" = false;
        "browser.urlbar.suggest.pocket" = false;
        "browser.urlbar.suggest.remotetab" = false;

        # firefox suggest (sponsored / online suggestions)
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.quicksuggest.enabled" = false;

        # inline url autofill and search-mode suggestions
        "browser.urlbar.autoFill" = false;
        "browser.urlbar.autoFill.adaptiveHistory.enabled" = false;

        # master toggle for search suggestions in the urlbar and search bar
        "browser.search.suggest.enabled" = false;

        ### new tab page shortcuts (top sites row)

        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 0;

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

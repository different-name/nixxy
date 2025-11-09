{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.firefox.enable {
    programs.firefox.profiles.default.settings = {
      ### custom
      # disable pocket
      "extensions.pocket.enabled" = false;

      # disable about:config warning
      "browser.aboutConfig.showWarning" = false;

      # force dark style
      "layout.css.prefers-color-scheme.content-override" = 0;

      ### startup
      # disable sponsored content on Firefox Home (Activity Stream)
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      # clear default top sites
      "browser.newtabpage.activity-stream.default.sites" = "";

      ### geolocation
      # disable use of linux geolocation service
      "geo.provider.use_geoclue" = false;

      ### quieter fox
      # disable recommendation pane in about:addons (uses Google Analytics)
      "extensions.getAddons.showPane" = false;
      # disable recommendations in about:addons' Extensions and Themes panes
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      # disable personalized Extension Recommendations in about:addons and AMO
      "browser.discovery.enabled" = false;
      # disable shopping experience
      "browser.shopping.experience2023.enabled" = false;

      ### telemetry
      # disable new data submission
      "datareporting.policy.dataSubmissionEnabled" = false;
      # disable Health Reports
      "datareporting.healthreport.uploadEnabled" = false;
      # disable telemetry
      "toolkit.telemetry.unified" = false;
      "toolkit.telemetry.enabled" = false;
      "toolkit.telemetry.server" = "data:,";
      "toolkit.telemetry.archive.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      # disable Telemetry Coverage
      "toolkit.telemetry.coverage.opt-out" = true;
      "toolkit.coverage.opt-out" = true;
      "toolkit.coverage.endpoint.base" = "";
      # disable Firefox Home (Activity Stream) telemetry
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "browser.newtabpage.activity-stream.telemetry" = false;

      ### studies
      # disable studies
      "app.shield.optoutstudies.enabled" = false;
      # disable Normandy/Shield
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";

      ### crash reports
      # disable crash reports
      "breakpad.reportURL" = "";
      "browser.tabs.crashReporting.sendReport" = false;
      # enforce no submission of backlogged crash reports
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

      ### other
      # disable Captive Portal detection
      "captivedetect.canonicalURL" = "";
      "network.captive-portal-service.enabled" = false;
      # disable Network Connectivity checks
      "network.connectivity-service.enabled" = false;

      ### safe browsing
      # disable safe browsing checks for downloads (remote)
      "browser.safebrowsing.downloads.remote.enabled" = false;

      ### block implicit outbound
      # disable link prefetching
      "network.prefetch-next" = false;
      # disable dns prefetching
      "network.dns.disablePrefetch" = true;
      "network.dns.disablePrefetchFromHTTPS" = true;
      # disable predictor / prefetching
      "network.predictor.enabled" = false;
      "network.predictor.enable-prefetch" = false;
      # disable link-mouseover opening connection to linked server
      "network.http.speculative-parallel-limit" = 0;
      # disable mousedown speculative connections on bookmarks and history
      "browser.places.speculativeConnect.enabled" = false;

      ### DNS / DoH / proxy / SOCKS
      # set the proxy server to do any DNS lookups when using SOCKS
      "network.proxy.socks_remote_dns" = true;
      # disable using UNC (Uniform Naming Convention) paths
      "network.file.disable_unc_paths" = true;
      # disable GIO as a potential proxy bypass vector
      "network.gio.supported-protocols" = "";

      ### location bar / search bar / suggestions / history / forms
      # disable location bar making speculative connections
      "browser.urlbar.speculativeConnect.enabled" = false;
      # disable location bar contextual suggestions
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
      "browser.urlbar.suggest.quicksuggest.sponsored" = false;
      # disable live search suggestions
      "browser.search.suggest.enabled" = false;
      "browser.urlbar.suggest.searches" = false;
      # disable urlbar trending search suggestions
      "browser.urlbar.trending.featureGate" = false;
      # disable urlbar suggestions
      "browser.urlbar.addons.featureGate" = false;
      "browser.urlbar.mdn.featureGate" = false;
      "browser.urlbar.pocket.featureGate" = false;
      "browser.urlbar.weather.featureGate" = false;
      "browser.urlbar.yelp.featureGate" = false;
      # disable search and form history
      "browser.formfill.enable" = false;

      ### passwords
      # disable auto-filling username & password form fields
      "signon.autofillForms" = false;
      # disable formless login capture for Password Manager
      "signon.formlessCapture.enabled" = false;
      # limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources
      "network.auth.subresource-http-auth-allow" = 1;

      ### disk avoidance
      # disable media cache from writing to disk in Private Browsing
      "browser.privatebrowsing.forceMediaMemoryCache" = true;
      "media.memory_cache_max_size" = 65536;

      ### SSL/TLS
      # require safe negotiation
      "security.ssl.require_safe_negotiation" = true;
      # disable TLS1.3 0-RTT (round-trip time)
      "security.tls.enable_0rtt_data" = false;

      ### OCSP
      # enforce OCSP fetching to confirm current validity of certificates
      "security.OCSP.enabled" = 1;
      # set OCSP fetch failures to hard-fail
      "security.OCSP.require" = true;

      ### CERTS / HPKP
      # enable strict PKP (Public Key Pinning)
      "security.cert_pinning.enforcement_level" = 2;
      # enable CRLite
      "security.remote_settings.crlite_filters.enabled" = true;
      "security.pki.crlite_mode" = 2;

      ### mixed content
      # enable HTTPS-Only mode in all windows
      "dom.security.https_only_mode" = true;
      # disable HTTP background requests
      "dom.security.https_only_mode_send_http_background_request" = false;

      ### UI
      # display warning on the padlock for "broken security"
      "security.ssl.treat_unsafe_negotiation_as_broken" = true;
      # display advanced information on Insecure Connection warning pages
      "browser.xul.error_pages.expert_bad_cert" = true;

      ### referrers
      # control the amount of cross-origin information to send
      "network.http.referer.XOriginTrimmingPolicy" = 2;

      ### plugins / media / WebRTC
      # force WebRTC inside the proxy
      "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
      # force a single network interface for ICE candidates generation
      "media.peerconnection.ice.default_address_only" = true;

      ### DOM
      # prevent scripts from moving and resizing open windows
      "dom.disable_window_move_resize" = true;

      ### miscellaneous
      # remove temp files opened from non-PB windows with an external application
      "browser.download.start_downloads_in_tmp_dir" = true;
      "browser.helperApps.deleteTempFileOnExit" = true;
      # disable UITour backend so there is no chance that a remote page can use it
      "browser.uitour.enabled" = false;
      # reset remote debugging to disabled
      "devtools.debugger.remote-enabled" = false;
      # remove special permissions for certain mozilla domains
      "permissions.manager.defaultsUrl" = "";
      # remove webchannel whitelist
      "webchannel.allowObject.urlWhitelist" = "";
      # use Punycode in Internationalized Domain Names to eliminate possible spoofing
      "network.IDN_show_punycode" = true;
      # enforce PDFJS, disable PDFJS scripting
      "pdfjs.disabled" = false;
      "pdfjs.enableScripting" = false;
      # disable middle click on new tab button opening URLs or searches using clipboard
      "browser.tabs.searchclipboardfor.middleclick" = false;
      # disable content analysis by DLP (Data Loss Prevention) agents
      "browser.contentanalysis.enabled" = false;
      "browser.contentanalysis.default_result" = 0;

      ### downloads
      # enable user interaction for security by always asking where to download
      "browser.download.useDownloadDir" = false;
      # disable downloads panel opening on every download
      "browser.download.alwaysOpenPanel" = false;
      # disable adding downloads to the system's "recent documents" list
      "browser.download.manager.addToRecentDocs" = false;
      # enable user interaction for security by always asking how to handle new mimetypes
      "browser.download.always_ask_before_handling_new_types" = true;

      ### extensions
      # limit allowed extension directories
      "extensions.enabledScopes" = 5;
      # disable bypassing 3rd party extension install prompts
      "extensions.postDownloadThirdPartyPrompt" = false;

      ### ETP (ENHANCED TRACKING PROTECTION)
      # enable ETP Strict Mode
      "browser.contentblocking.category" = "standard"; # adnauseum: modified from "strict"

      ### fingerprinting protection
      # enforce links targeting new windows to open in a new tab instead
      "browser.link.open_newwindow" = 3;
      # set all open window methods to abide by "browser.link.open_newwindow"
      "browser.link.open_newwindow.restriction" = 0;

      ### don't touch
      # enforce Firefox blocklist
      "extensions.blocklist.enabled" = false; # adnauseum: modified from true
      # enforce no referer spoofing
      "network.http.referer.spoofSource" = false;
      # enforce a (shortened) security delay on some confirmation dialogs such as install, open/save
      "security.dialog_enable_delay" = 500;
      # enforce no First Party Isolation
      "privacy.firstparty.isolate" = false;
      # enforce SmartBlock shims (about:compat)
      "extensions.webcompat.enable_shims" = true;
      # enforce no TLS 1.0/1.1 downgrades
      "security.tls.version.enable-deprecated" = false;
      # enforce disabling of Web Compatibility Reporter
      "extensions.webcompat-reporter.enabled" = false;
      # enforce Quarantined Domains
      "extensions.quarantinedDomains.enabled" = true;

      ### extra misc
      # disable welcome notices
      "browser.startup.homepage_override.mstone" = "ignore";
      # disable General>Browsing>Recommend extensions/features as you browse
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
      "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
      # disable search terms
      "browser.urlbar.showSearchTerms.enabled" = false;
    };
  };
}

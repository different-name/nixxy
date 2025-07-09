{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.firefox.enable {
    programs.firefox.profiles.default.search = {
      force = true;
      default = "google";
      engines = {
        # keep-sorted start block=yes newline_separated=yes
        "HM Options" = {
          urls = lib.singleton {
            template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
          };
          definedAliases = [ ":hm" ];
        };

        "Nix Options" = {
          urls = lib.singleton {
            template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
          };
          definedAliases = [ ":no" ];
        };

        "Nix Packages" = {
          urls = lib.singleton {
            template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
          };
          definedAliases = [ ":np" ];
        };

        "Noogle" = {
          urls = lib.singleton {
            template = "https://noogle.dev/q?term={searchTerms}";
          };
          definedAliases = [ ":ng" ];
        };

        "Proton DB" = {
          urls = lib.singleton {
            template = "https://www.protondb.com/search?q={searchTerms}";
          };
          definedAliases = [ ":pd" ];
        };

        "Youtube" = {
          urls = lib.singleton {
            template = "https://www.youtube.com/results?search_query={searchTerms}";
          };
          definedAliases = [ ":yt" ];
        };
        # keep-sorted end

        # keep-sorted start
        "Wikipedia".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "ddg".metaData.hidden = true;
        "google".metaData.alias = ":g";
        # keep-sorted end
      };
    };
  };
}

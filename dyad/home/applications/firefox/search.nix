{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.firefox.enable {
    programs.firefox.profiles.default.search = {
      force = true;
      default = "google";
      engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }
          ];
          definedAliases = [ ":np" ];
        };

        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }
          ];
          definedAliases = [ ":no" ];
        };

        "HM Options" = {
          urls = [
            {
              template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
            }
          ];
          definedAliases = [ ":hm" ];
        };

        "Proton DB" = {
          urls = [
            {
              template = "https://www.protondb.com/search?q={searchTerms}";
            }
          ];
          definedAliases = [ ":pd" ];
        };

        "Youtube" = {
          urls = [
            {
              template = "https://www.youtube.com/results?search_query={searchTerms}";
            }
          ];
          definedAliases = [ ":yt" ];
        };

        "Noogle" = {
          urls = [
            {
              template = "https://noogle.dev/q?term={searchTerms}";
            }
          ];
          definedAliases = [ ":ng" ];
        };

        "google".metaData.alias = ":g";
        "ddg".metaData.hidden = true;
        "bing".metaData.hidden = true;
        "Wikipedia".metaData.hidden = true;
      };
    };
  };
}

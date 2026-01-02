{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.librewolf.enable {
    programs.librewolf.profiles.default.search = {
      force = true;
      default = "kagi";
      engines = {
        # keep-sorted start block=yes newline_separated=yes
        hm-options = {
          name = "HM Options";
          urls = lib.singleton {
            template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master";
          };
          definedAliases = [ ":hm" ];
        };

        kagi = {
          name = "Kagi";
          urls = lib.singleton {
            template = "https://kagi.com/search?q={searchTerms}";
          };
          definedAliases = [ ":kg" ];
        };

        nixos-options = {
          name = "NixOS Options";
          urls = lib.singleton {
            template = "https://search.nixos.org/options?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
          };
          definedAliases = [ ":no" ];
        };

        nixpkgs = {
          name = "Nix Packages";
          urls = lib.singleton {
            template = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
          };
          definedAliases = [ ":np" ];
        };

        noogle = {
          name = "Noogle";
          urls = lib.singleton {
            template = "https://noogle.dev/q?term={searchTerms}";
          };
          definedAliases = [ ":ng" ];
        };

        proton-db = {
          name = "Proton DB";
          urls = lib.singleton {
            template = "https://www.protondb.com/search?q={searchTerms}";
          };
          definedAliases = [ ":pd" ];
        };

        warframe-wiki = {
          name = "Warframe Wiki";
          urls = lib.singleton {
            template = "https://wiki.warframe.com/?title=Special:Search&search={searchTerms}";
          };
          definedAliases = [ ":wf" ];
        };

        youtube = {
          name = "Youtube";
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
        "google".metaData.hidden = true;
        # keep-sorted end
      };
    };
  };
}

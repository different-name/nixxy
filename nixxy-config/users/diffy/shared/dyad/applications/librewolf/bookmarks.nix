{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.applications.librewolf.enable {
    hm.programs.librewolf.profiles.default = {
      bookmarks = {
        force = true;

        settings = [
          {
            name = "Media";
            bookmarks = [
              {
                name = "YouTube";
                url = "https://www.youtube.com/";
              }
              {
                name = "VRChat";
                url = "https://vrchat.com/home";
              }
            ];
          }

          {
            name = "Personal";
            bookmarks = [
              {
                name = "Mail";
                url = "https://account.proton.me/mail";
              }
              {
                name = "Drive";
                url = "https://account.proton.me/drive";
              }
              {
                name = "Copyparty";
                url = "https://copyparty.different-name.com/";
              }
              {
                name = "Photos";
                url = "https://web.ente.io/gallery";
              }
              {
                name = "Kagi Assistant";
                url = "https://kagi.com/assistant";
              }
            ];
          }

          {
            name = "GitHub";
            bookmarks = [
              {
                name = "nixxy";
                url = "https://github.com/different-name/nixxy";
              }
              {
                name = "steam-config-nix";
                url = "https://github.com/different-name/steam-config-nix";
              }
              {
                name = "moonlight-mod";
                url = "https://github.com/moonlight-mod/moonlight";
              }
            ];
          }

          {
            name = "Work";
            bookmarks = [
              {
                name = "Vault";
                url = "https://login.vaultre.com.au/cgi-bin/clientvault/login.cgi?id=rw";
              }
              {
                name = "id4me";
                url = "https://id4me.me/";
              }
              {
                name = "Monday.com";
                url = "https://raywhite816007.monday.com/";
              }
              {
                name = "Google Sheets";
                url = "https://docs.google.com/spreadsheets/u/1/";
              }
              {
                name = "Google Mail";
                url = "https://mail.google.com/mail/u/1/";
              }
              {
                name = "PriceFinder";
                url = "https://app.pricefinder.com.au/v4/app";
              }
              {
                name = "One System";
                url = "https://sites.google.com/raywhite.com/raywhite-onesystem/au";
              }
              {
                name = "My Raywhite";
                url = "https://my.raywhite.com/dashboard/home";
              }
              {
                name = "Developmenti";
                url = "https://developmenti.sunshinecoast.qld.gov.au";
              }
              {
                name = "VentraIP";
                url = "https://vip.ventraip.com.au/dashboard";
              }
            ];
          }
        ];
      };
    };
  };
}

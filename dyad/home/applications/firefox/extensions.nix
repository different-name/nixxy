{
  lib,
  config,
  inputs',
  self',
  ...
}:
{
  config = lib.mkIf config.dyad.applications.firefox.enable {
    programs.firefox.profiles.default = {
      extensions = {
        force = true;

        settings = {
          # redirector, credit to https://github.com/Anomalocaridid/dotfiles/blob/2eff267391847977118cef00baaac2ef690d2068/home-modules/librewolf.nix#L183-L201
          "redirector@einaregilsson.com" = {
            force = true;
            settings = {
              enableNotifications = false;
              redirects = lib.singleton {
                description = "NixOS Wiki";
                exampleUrl = "https://nixos.wiki/wiki/Nix_package_manager";
                exampleResult = "https://wiki.nixos.org/wiki/Nix_package_manager";
                includePattern = "https://nixos.wiki/*";
                redirectUrl = "https://wiki.nixos.org/$1";
                patternType = "W"; # wildcard
                appliesTo = [ "main_frame" ];
              };
            };
          };
        };

        packages = with inputs'.nur.legacyPackages.repos.rycee.firefox-addons; [
          # keep-sorted start
          dearrow
          greasemonkey
          proton-pass
          proton-vpn
          redirector
          self'.packages.catppuccin-firefox-mocha
          sponsorblock
          stylus
          twitch-auto-points
          ublock-origin
          youtube-nonstop
          # keep-sorted end
        ];
      };

      # auto enable extensions
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
    };

    # download update import file for stylus catppuccin userstyles
    home.shellAliases.ctpuserstyles = ''
      curl -sL https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json | sed -E 's/"default":"(rosewater|flamingo|pink|mauve|red|maroon|peach|green|yellow|teal|blue|sapphire|grey|lavender)"/"default":"red"/g' > ~/import.json
    '';
  };
}

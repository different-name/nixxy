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
          # keep-sorted start block=yes newline_separated=yes
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

          # stylus
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
            force = true;
            settings =
              let
                inherit (config.catppuccin) flavor accent;

                userstylesConfig = {
                  # default settings applied to all userstyles
                  defaultSettings = {
                    lightFlavor = flavor;
                    darkFlavor = flavor;
                    accentColor = accent;
                  };

                  # settings applied per userstyle
                  # userstyles = lib.mapAttrs' (name: value: {
                  #   name = "${name} catppuccin";
                  #   value = { inherit (value) enable settings exclusions; };
                  # }) { };
                };

                settingsPackage = self'.packages.catppuccin-userstyles.override { inherit userstylesConfig; };
              in
              lib.importJSON "${settingsPackage}/share/storage.js";
          };
          # keep-sorted end
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
  };
}

{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  config = lib.mkIf config.nix-files.parts.applications.firefox.enable {
    programs.firefox.profiles.default = {
      extensions = {
        force = true;

        settings = {
          # redirector
          # https://github.com/Anomalocaridid/dotfiles/blob/2eff267391847977118cef00baaac2ef690d2068/home-modules/librewolf.nix#L183-L201
          "redirector@einaregilsson.com" = {
            force = true;
            settings = {
              enableNotifications = false;
              redirects = [
                {
                  description = "NixOS Wiki";
                  exampleUrl = "https://nixos.wiki/wiki/Nix_package_manager";
                  exampleResult = "https://wiki.nixos.org/wiki/Nix_package_manager";
                  includePattern = "https://nixos.wiki/*";
                  redirectUrl = "https://wiki.nixos.org/$1";
                  patternType = "W"; # wildcard
                  appliesTo = [ "main_frame" ];
                }
              ];
            };
          };
        };

        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          # util
          proton-pass
          proton-vpn
          greasemonkey
          redirector

          # style
          stylus
          firefox-color
          inputs.self.packages.${pkgs.system}.catppuccin-firefox-mocha

          # adblock
          ublock-origin
          dearrow
          sponsorblock
          youtube-nonstop
        ];
      };

      # auto enable extensions
      settings = {
        "extensions.autoDisableScopes" = 0;
      };
    };
  };
}

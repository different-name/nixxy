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

        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          # util
          proton-pass
          proton-vpn
          greasemonkey
          redirector

          # style
          stylus
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

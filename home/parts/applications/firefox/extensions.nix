{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.nix-files.parts.applications.firefox.enable {
    programs.firefox.profiles.default.extensions = {
      force = true;

      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        proton-pass
        proton-vpn
        dearrow
        sponsorblock
        stylus
        youtube-nonstop
        greasemonkey
        redirector
        firefox-color
      ];
    };
  };
}

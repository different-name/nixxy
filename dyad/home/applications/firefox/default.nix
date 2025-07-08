{ lib, config, ... }:
{
  options.dyad.applications.firefox.enable = lib.mkEnableOption "firefox config";

  config = lib.mkIf config.dyad.applications.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
        };
      };
    };

    dyad.system.persistence.dirs = [
      # keep-sorted start
      ".cache/mozilla/firefox"
      ".mozilla/firefox"
      # keep-sorted end
    ];
  };
}

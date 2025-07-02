{ lib, config, ... }:
{
  options.nix-files.parts.applications.firefox.enable = lib.mkEnableOption "firefox config";

  config = lib.mkIf config.nix-files.parts.applications.firefox.enable {
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

    nix-files.parts.system.persistence = {
      directories = [
        ".mozilla/firefox"
        ".cache/mozilla/firefox"
      ];
    };
  };
}

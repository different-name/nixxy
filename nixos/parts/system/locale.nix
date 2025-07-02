{ lib, config, ... }:
{
  options.nix-files.parts.system.locale.enable = lib.mkEnableOption "locale config";

  config = lib.mkIf config.nix-files.parts.system.locale.enable {
    time.timeZone = "Australia/Brisbane";
    i18n.defaultLocale = "en_AU.UTF-8";

    console.useXkbConfig = true; # use xkb layout for console
    services.xserver.xkb.layout = "us"; # not used in hyprland
  };
}

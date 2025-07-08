{
  lib,
  config,
  inputs,
  inputs',
  self,
  pkgs,
  ...
}:
let
  discordPackage = pkgs.discord.override {
    withMoonlight = true;
    moonlight = inputs'.moonlight.packages.moonlight-mod;
  };
in
{
  imports = [
    inputs.moonlight.homeModules.default
    self.homeModules.disblockOrigin
  ];

  options.dyad.applications.discord.enable = lib.mkEnableOption "discord config";

  config = lib.mkIf config.dyad.applications.discord.enable {
    programs.moonlight-mod = {
      enable = true;
      configs.stable = import ./_moonlight-config.nix;
    };

    xdg.configFile."moonlight-mod/stable.json".force = true;

    programs.disblockOrigin = {
      enable = true;
      settings = {
        gif-button = true;
        active-now = false;
        clan-tags = false;
        settings-billing-header = false;
        settings-gift-inventory-tab = false;
      };
    };

    home.packages = [
      discordPackage
      (pkgs.writeShellScriptBin "moonlight-config-updater" (
        builtins.readFile ./moonlight-config-updater.sh
      ))
    ];

    xdg.autostart.entries = [
      (discordPackage + /share/applications/discord.desktop)
    ];

    dyad.system.persistence.dirs = [
      ".config/discord"
      ".config/moonlight-mod"
    ];
  };
}

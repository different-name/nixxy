{
  lib,
  config,
  inputs,
  self,
  pkgs,
  ...
}: {
  imports = [
    inputs.moonlight.homeModules.default
    self.homeManagerModules.disblock-origin
  ];

  options.nix-files.graphical.games.discord.enable = lib.mkEnableOption "Discord config";

  config = lib.mkIf config.nix-files.graphical.games.discord.enable {
    programs.moonlight-mod = {
      enable = true;
      configs.stable = import ./moonlight-config.nix;
    };

    xdg.configFile."moonlight-mod/stable.json".force = true;

    programs.disblock-origin = {
      enable = true;
      settings = {
        gif-button = true;
        active-now = false;
        clan-tags = false;
        settings-billing-header = false;
        settings-gift-inventory-tab = false;
      };
    };

    home.packages = with pkgs; [
      (discord.override {withMoonlight = true;})
      (
        pkgs.writeShellScriptBin
        "moonlight-config-updater"
        (builtins.readFile ./moonlight-config-updater.sh)
      )
    ];

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/discord"
        ".config/moonlight-mod"
      ];
    };
  };
}

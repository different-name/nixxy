{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.moonlight.homeModules.default
  ];

  options.nix-files.graphical.games.discord.enable = lib.mkEnableOption "Discord config";

  config = lib.mkIf config.nix-files.graphical.games.discord.enable {
    programs.moonlight-mod = {
      enable = true;
      configs.stable = import ./moonlight-config.nix;
    };

    xdg.configFile."moonlight-mod/stable.json".force = true;
    xdg.configFile."moonlight-mod/styles.css".source = ./styles.css;

    home.packages = with pkgs; [
      (discord.override {withMoonlight = true;})
      (
        pkgs.writeShellScriptBin
        "moonlight-config-updater"
        (builtins.readFile ./moonlight-config-updater.sh)
      )
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/discord"
        ".config/moonlight-mod"
      ];
    };
  };
}

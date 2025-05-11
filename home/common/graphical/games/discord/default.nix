{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.games.discord.enable = lib.mkEnableOption "Discord config";

  config = lib.mkIf config.nix-files.graphical.games.discord.enable {
    home.packages = let
      vencord = pkgs.vencord.overrideAttrs {
        patches = [./disableSupportHelper.patch];
      };

      discord = pkgs.discord.override {
        inherit vencord;
        withVencord = true;
      };
    in [discord];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/discord"
        ".config/Vencord"
      ];
    };
  };
}

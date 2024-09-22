{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.util.unity.enable = lib.mkEnableOption "Unity config";

  config = lib.mkIf config.nix-files.graphical.util.unity.enable {
    home = {
      packages = with pkgs; [
        unityhub
        vrc-get
      ];

      persistence."/persist${config.home.homeDirectory}" = {
        directories = [
          # unityhub
          ".config/unityhub"
          ".config/Unity"
          ".config/unity3d" # seems to also be for unity games
          ".local/share/unity3d"

          # vrc-get
          ".local/share/VRChatCreatorCompanion"
        ];
      };
    };
  };
}

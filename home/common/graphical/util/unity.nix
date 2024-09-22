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

      persistence = lib.mkIf config.nix-files.persistence.enable {
        "/persist${config.home.homeDirectory}" = {
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

        "/persist${config.home.homeDirectory}-cache" = {
          directories = [
            # unityhub
            ".config/unityhub/Cache"
            ".config/unityhub/DawnCache"
            ".config/unityhub/Code Cache"
            ".config/unityhub/GPUCache"
            ".config/unityhub/graphqlCache"
            ".config/unityhub/Service Worker/CacheStorage"
            ".config/unityhub/Storage/ext/fake-host/def/GPUCache"
            ".config/unityhub/Storage/ext/fake-host/def/DawnCache"
            ".config/unity3d/cache" # seems to also be for unity games
            ".local/share/unity3d/cache"
          ];
        };
      };
    };
  };
}

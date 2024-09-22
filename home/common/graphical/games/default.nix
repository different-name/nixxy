{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
  ];

  options.nix-files.graphical.games.enable = lib.mkEnableOption "Games packages";

  config = lib.mkIf config.nix-files.graphical.games.enable {
    home.packages = with pkgs; [
      vesktop
      lutris
      heroic
      osu-lazer-bin
      (prismlauncher.override {
        jdks = [
          zulu8
          zulu17
          zulu21
        ];
      })
    ];

    home.persistence = lib.mkIf config.nix-files.persistence.enable {
      "/persist${config.home.homeDirectory}" = {
        directories = [
          # vesktop
          ".config/vesktop"

          # lutris
          ".local/share/lutris"
          ".local/share/umu" # proton runtime

          # heroic
          ".config/heroic"

          # osu-lazer
          ".local/share/osu"

          # prism launcher
          ".local/share/PrismLauncher"
        ];
      };

      "/persist${config.home.homeDirectory}-cache" = {
        directories = [
          # general
          ".nv" # OpenGL cache
          ".local/share/vulkan/"

          # vesktop
          ".config/vesktop/sessionData/Cache"
          ".config/vesktop/sessionData/Code Cache"
          ".config/vesktop/sessionData/GPUCache"
          ".config/vesktop/sessionData/DawnWebGPUCache"
          ".config/vesktop/sessionData/Shared Dictionary/cache"
          ".config/vesktop/sessionData/DawnGraphiteCache"

          # heroic
          ".config/heroic/Cache"
          ".config/heroic/store_cache"
          ".config/heroic/images-cache"
          ".config/heroic/GPUCache"
          ".config/heroic/DawnCache"
          ".config/heroic/Code Cache"
          ".config/heroic/Shared Dictionary/cache"
          ".config/heroic/Partitions/epicstore/Cache"
          ".config/heroic/Partitions/epicstore/Code Cache"
          ".config/heroic/Partitions/epicstore/GPUCache"
          ".config/heroic/Partitions/epicstore/DawnCache"
          ".config/heroic/Partitions/epicstore/Shared Dictionary/cache"
        ];
      };
    };
  };
}

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
      osu-lazer-bin
      rpcs3
      (discord.override {
        withVencord = true;
      })
      (prismlauncher.override {
        jdks = [
          zulu8
          zulu17
          zulu21
        ];
      })
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # general
        ".nv" # OpenGL cache
        ".local/share/vulkan/" # shader cache files?
        ".cache/mesa_shader_cache_db" # shader cache

        # vesktop
        ".config/vesktop"

        # lutris
        ".local/share/lutris"
        ".cache/lutris"
        ".local/share/umu" # proton runtime

        # osu-lazer
        ".local/share/osu"

        # rpcs3
        ".config/rpcs3"
        ".cache/rpcs3"

        # discord
        ".config/discord"

        # prism launcher
        ".local/share/PrismLauncher"
      ];
    };
  };
}

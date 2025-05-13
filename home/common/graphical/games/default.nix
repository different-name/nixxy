{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./steam.nix
    ./xr.nix
  ];

  options.nix-files.graphical.games.enable = lib.mkEnableOption "Games packages";

  config = lib.mkIf config.nix-files.graphical.games.enable {
    home.packages = with pkgs; [
      discord
      lutris
      osu-lazer-bin
      rpcs3
      prismlauncher
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # general
        ".nv" # OpenGL cache
        ".local/share/vulkan/" # shader cache files?
        ".cache/mesa_shader_cache_db" # shader cache

        # discord
        ".config/discord"
        ".config/Vencord"

        # lutris
        ".local/share/lutris"
        ".cache/lutris"
        ".local/share/umu" # proton runtime

        # osu-lazer
        ".local/share/osu"

        # rpcs3
        ".config/rpcs3"
        ".cache/rpcs3"

        # prism launcher
        ".local/share/PrismLauncher"
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./xr
    ./discord
    ./steam.nix
  ];

  options.nix-files.graphical.games.enable = lib.mkEnableOption "Games packages";

  config = lib.mkIf config.nix-files.graphical.games.enable {
    home.packages = with pkgs; [
      lutris
      osu-lazer-bin

      (prismlauncher.override {
        jdks = [
          pkgs.temurin-bin
        ];
      })
    ];

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # general
        ".nv" # OpenGL cache
        ".local/share/vulkan/" # shader cache files?
        ".cache/mesa_shader_cache_db" # shader cache

        # lutris
        ".local/share/lutris"
        ".cache/lutris"
        ".local/share/umu" # proton runtime

        # osu-lazer
        ".local/share/osu"

        # prism launcher
        ".local/share/PrismLauncher"
      ];
    };
  };
}

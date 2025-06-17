{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.nix-files.parts.games.extra-packages.enable = lib.mkEnableOption "extra games packages";

  config = lib.mkIf config.nix-files.parts.games.extra-packages.enable {
    home.packages = with pkgs; [
      lutris
      osu-lazer-bin

      (prismlauncher.override {
        jdks = [
          pkgs.temurin-bin
        ];
      })
    ];

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
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

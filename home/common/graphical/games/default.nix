{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  imports = [
    ./steam.nix
    ./xr.nix
  ];

  options.nix-files.graphical.games.enable = lib.mkEnableOption "Games packages";

  config = lib.mkIf config.nix-files.graphical.games.enable {
    home.packages = with pkgs; [
      (discord.override {
        withVencord = true;
        # let me disable the silly popups
        vencord = pkgs.vencord.overrideAttrs (old: {
          patches =
            (old.patches or [])
            ++ ["${self}/patches/vencord/make-support-helper-optional.patch"];
        });
      })

      lutris
      osu-lazer-bin

      (prismlauncher.override {
        jdks = [
          pkgs.temurin-bin
        ];
      })

      rpcs3
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

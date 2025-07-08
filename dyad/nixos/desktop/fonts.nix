{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.desktop.fonts.enable = lib.mkEnableOption "fonts config";

  config = lib.mkIf config.dyad.desktop.fonts.enable {
    fonts = {
      packages = with pkgs; [
        # sans(serif) fonts
        # keep-sorted start block=yes
        (google-fonts.override {
          fonts = [
            "Inter"
            "Nunito"
          ];
        })
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        roboto
        # keep-sorted end

        # monospace fonts
        jetbrains-mono

        # nerdfonts
        nerd-fonts.symbols-only

        # symbols
        symbola
      ];

      # apparently causes more issues than it fixes
      enableDefaultPackages = false;

      # user defined fonts
      # Noto Color Emoji is used in all to override DejaVu's B&W emojis
      fontconfig.defaultFonts =
        let
          addAll = builtins.mapAttrs (_k: v: v ++ [ "Symbols Nerd Font" ] ++ [ "Noto Color Emoji" ]);
        in
        addAll {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Inter" ];
          monospace = [
            "JetBrains Mono"
            "Symbola"
          ];
          emoji = [ ];
        };
    };

    environment.persistence-wrapper.home.dirs = [
      ".cache/fontconfig"
    ];
  };
}

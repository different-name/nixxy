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
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        roboto
        (google-fonts.override {
          fonts = [
            "Inter"
            "Nunito"
          ];
        })

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
          addAll = builtins.mapAttrs (k: v: v ++ [ "Symbols Nerd Font" ] ++ [ "Noto Color Emoji" ]);
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

    dyad.system.persistence = {
      home.directories = [
        ".cache/fontconfig"
      ];
    };
  };
}

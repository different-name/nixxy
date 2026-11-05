{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "fonts" ] {
  nixos = { pkgs, ... }: {
    fonts = {
      packages = with pkgs; [
        # sans(serif) fonts
        (google-fonts.override {
          fonts = [
            "Onest"
            "Nunito"
          ];
        })
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        roboto

        # monospace fonts
        maple-mono.truetype

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
          addAll = lib.mapAttrs (_k: v: v ++ [ "Symbols Nerd Font" ] ++ [ "Noto Color Emoji" ]);
        in
        addAll {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Onest" ];
          monospace = [
            "Maple Mono"
            "Symbola"
          ];
          emoji = [ ];
        };
    };
  };

  home-manager.keep.loose.cacheDirs = [ "fontconfig" ];
}

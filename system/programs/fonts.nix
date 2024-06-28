{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      # sans(serif) fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      roboto
      (google-fonts.override {fonts = ["Inter"];})
      
      # nerdfonts
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly" "JetBrainsMono"];})
    ];

    # apparently causes more issues than it fixes
    enableDefaultPackages = false;

    # user defined fonts
    # Noto Color Emoji is used in all to override DejaVu's B&W emojis
    fontconfig.defaultFonts = let
      addAll = builtins.mapAttrs (k: v: ["Symbols Nerd Font"] ++ v ++ ["Noto Color Emoji"]);
    in
      addAll {
        serif = ["Noto Serif"];
        sansSerif = ["Inter"];
        monospace = ["JetBrainsMono Nerd Font"];
        emoji = [];
      };
  };
}
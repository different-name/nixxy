{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.programs.fonts.enable = lib.mkEnableOption "Fonts config";

  config = lib.mkIf config.nix-files.programs.fonts.enable {
    fonts = {
      packages = with pkgs; [
        # sans(serif) fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
        roboto
        (google-fonts.override {fonts = ["Inter"];})

        # monospace fonts
        jetbrains-mono

        # nerdfonts
        (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})

        # symbols
        symbola
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
          monospace = ["JetBrains Mono" "Symbola"];
          emoji = [];
        };
    };
  };
}

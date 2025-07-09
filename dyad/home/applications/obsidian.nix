{
  lib,
  config,
  self',
  ...
}:
{
  options.dyad.applications.obsidian.enable = lib.mkEnableOption "obsidian config";

  config = lib.mkIf config.dyad.applications.obsidian.enable {
    programs.obsidian = {
      enable = true;
      defaultSettings = {
        app = {
          spellcheck = false;
        };

        appearance = {
          theme = "obsidian"; # dark base color scheme
          accentColor = "#cba6f7";
          interfaceFontFamily = "Jetbrains Mono";
          textFontFamily = "Jetbrains Mono";
          monospaceFontFamily = "Jetbrains Mono";
        };

        themes = lib.singleton {
          enable = true;
          pkg = self'.packages.catppuccin-obsidian-theme;
        };
      };

      vaults."Diffy Notes" = {
        target = "Documents/Obsidian/Diffy Notes";
      };
    };

    home.file =
      [
        # keep-sorted start
        "app.json"
        "appearance.json"
        "community-plugins.json"
        "core-plugins-migration.json"
        "core-plugins.json"
        "hotkeys.json"
        "themes/Catppuccin"
        # keep-sorted end
      ]
      |> map (path: {
        name = "Documents/Obsidian/Diffy Notes/.obsidian/${path}";
        value.force = true;
      })
      |> lib.listToAttrs;

    home.perpetual.default.dirs = [
      "$configHome/obsidian"
    ];
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  catppuccin-obsidian-theme = pkgs.stdenv.mkDerivation rec {
    pname = "catppuccin-obsidian-theme";
    version = "2.0.3";

    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "obsidian";
      rev = version;
      hash = "sha256-9fSFj9Tzc2aN9zpG5CyDMngVcwYEppf7MF1ZPUWFyz4=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r $src/. $out/
    '';

    meta = {
      description = "Soothing pastel theme for Obsidian";
      homepage = "https://github.com/catppuccin/obsidian";
      license = lib.licenses.mit;
      mainProgram = "catppuccin-obsidian-theme";
      platforms = lib.platforms.all;
    };
  };
in
{
  options.nix-files.parts.applications.obsidian.enable = lib.mkEnableOption "obsidian config";

  config = lib.mkIf config.nix-files.parts.applications.obsidian.enable {
    programs.obsidian = {
      enable = true;
      defaultSettings = {
        appearance = {
          theme = "obsidian"; # dark base color scheme
          accentColor = "#cba6f7";
          interfaceFontFamily = "Jetbrains Mono";
          textFontFamily = "Jetbrains Mono";
          monospaceFontFamily = "Jetbrains Mono";
        };

        themes = [
          {
            enable = true;
            pkg = catppuccin-obsidian-theme;
          }
        ];
      };

      vaults = {
        "Diffy Notes" = {
          target = "Documents/Obsidian/Diffy Notes";
        };
      };
    };

    home.file =
      [
        "app.json"
        "appearance.json"
        "community-plugins.json"
        "core-plugins-migration.json"
        "core-plugins.json"
        "hotkeys.json"
        "themes/Catppuccin"
      ]
      |> map (path: {
        name = "Documents/Obsidian/Diffy Notes/.obsidian/${path}";
        value.force = true;
      })
      |> lib.listToAttrs;

    nix-files.parts.system.persistence = {
      directories = [
        ".config/obsidian"
      ];
    };
  };
}

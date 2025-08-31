{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.dyad.applications.vscodium.enable = lib.mkEnableOption "vscodium config";

  config = lib.mkIf config.dyad.applications.vscodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          # keep-sorted start
          blueglassblock.better-json5
          dbaeumer.vscode-eslint
          editorconfig.editorconfig
          graphql.vscode-graphql
          graphql.vscode-graphql-syntax
          ms-python.python
          nefrob.vscode-just-syntax
          prettiercode.code-prettier
          tamasfe.even-better-toml
          # keep-sorted end
        ];

        userSettings = {
          # keep-sorted start block=yes
          "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
          "editor.fontLigatures" = true;
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmPasteNative" = false;
          "files.associations" = {
            "*.poiTemplateCollection" = "hlsl";
          };
          "files.enableTrash" = false;
          "git.confirmSync" = false;
          "git.detectSubmodules" = false;
          "git.repositoryScanMaxDepth" = 3;
          "scm.alwaysShowRepositories" = true;
          "window.titleBarStyle" = "custom";
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.iconTheme" = "catppuccin-mocha";
          "workbench.startupEditor" = "none";
          # keep-sorted end
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      # keep-sorted start
      "application/json" = "codium.desktop";
      "text/markdown" = "codium.desktop";
      "text/plain" = "codium.desktop";
      # keep-sorted end
    };

    wayland.windowManager.hyprland.settings.env = [
      "EDITOR,codium --wait"
    ];

    home.perpetual.default.dirs = [
      "$configHome/VSCodium"
    ];
  };
}

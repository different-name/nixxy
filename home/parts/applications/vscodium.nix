{
  lib,
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}:
{
  options.nix-files.parts.applications.vscodium.enable = lib.mkEnableOption "VSCodium config";

  config = lib.mkIf config.nix-files.parts.applications.vscodium.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;

      profiles.default = {
        extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
          jnoortheen.nix-ide
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          editorconfig.editorconfig
          tamasfe.even-better-toml
          blueglassblock.better-json5
          ms-python.python
        ];

        userSettings = {
          "window.titleBarStyle" = "custom";
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.startupEditor" = "none";

          "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
          "editor.tabSize" = 2;
          "editor.formatOnSave" = true;
          "editor.fontLigatures" = true;

          "files.enableTrash" = false;
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmPasteNative" = false;

          "scm.alwaysShowRepositories" = true;

          "git.detectSubmodules" = false;
          "git.confirmSync" = false;
          "git.repositoryScanMaxDepth" = 3;

          "files.associations" = {
            "*.poiTemplateCollection" = "hlsl";
          };

          # https://github.com/nix-community/vscode-nix-ide
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "${lib.getExe pkgs.nixd}";
          "nix.serverSettings.nixd.formatting.command" = [
            "${lib.getExe pkgs.nixfmt-rfc-style}"
          ];
          "nix.serverSettings.nixd.options.nixos.expr" =
            "(builtins.getFlake \"${osConfig.programs.nh.flake}\").nixosConfigurations.<name>.options";
          "nix.hiddenLanguageServerErrors" = [
            "textDocument/inlayHint"
            "textDocument/definition"
            "textDocument/completion"
            "textDocument/documentLink"
            "textDocument/hover"
            "textDocument/documentSymbol"
            "textDocument/codeAction"
            "textDocument/documentHighlight"
          ];
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "text/plain" = "codium.desktop";
      "application/json" = "codium.desktop";
      "text/markdown" = "codium.desktop";
    };

    wayland.windowManager.hyprland.settings.env = [
      "EDITOR,codium --wait"
    ];

    home.persistence."/persist" = lib.mkIf config.nix-files.parts.system.persistence.enable {
      directories = [
        ".config/VSCodium/CachedData"
        ".config/VSCodium/Cache"
        ".config/VSCodium/Backups"
        ".config/VSCodium/Code Cache"
        ".config/VSCodium/DawnCache"
        ".config/VSCodium/GPUCache"
        ".config/VSCodium/User/History"
        ".config/VSCodium/User/globalStorage"
        ".config/VSCodium/User/workspaceStorage"
        ".config/VSCodium/logs"
      ];
    };
  };
}

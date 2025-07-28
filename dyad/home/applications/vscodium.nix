{
  lib,
  config,
  inputs,
  self',
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
          editorconfig.editorconfig
          jnoortheen.nix-ide
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
          "nix.enableLanguageServer" = true;
          "nix.hiddenLanguageServerErrors" = [
            # keep-sorted start
            "textDocument/codeAction"
            "textDocument/completion"
            "textDocument/definition"
            "textDocument/documentHighlight"
            "textDocument/documentLink"
            "textDocument/documentSymbol"
            "textDocument/hover"
            "textDocument/inlayHint"
            # keep-sorted end
          ];
          "nix.serverPath" = "${lib.getExe pkgs.nixd}";
          "nix.serverSettings.nixd.formatting.command" = [
            (lib.getExe self'.formatter)
            "--quiet"
            "--stdin"
            "stump.nix"
          ];
          "nix.serverSettings.nixd.options.nixos.expr" =
            "(builtins.getFlake \"${config.programs.nh.flake}\").nixosConfigurations.<name>.options";
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
      # keep-sorted start
      "$configHome/VSCodium/Backups"
      "$configHome/VSCodium/Cache"
      "$configHome/VSCodium/CachedData"
      "$configHome/VSCodium/Code Cache"
      "$configHome/VSCodium/DawnCache"
      "$configHome/VSCodium/GPUCache"
      "$configHome/VSCodium/User/History"
      "$configHome/VSCodium/User/globalStorage"
      "$configHome/VSCodium/User/workspaceStorage"
      "$configHome/VSCodium/logs"
      # keep-sorted end
    ];
  };
}

{
  lib,
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  options.nix-files.graphical.util.vscodium.enable = lib.mkEnableOption "VSCodium config";

  config = lib.mkIf config.nix-files.graphical.util.vscodium.enable {
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
        ];

        userSettings = {
          "workbench.colorTheme" = "Catppuccin Mocha";
          "workbench.startupEditor" = "none";
          "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
          "editor.tabSize" = 2;
          "editor.formatOnSave" = true;
          "editor.fontLigatures" = true;
          "files.enableTrash" = false;
          "window.titleBarStyle" = "custom";
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmPasteNative" = false;

          "git.detectSubmodules" = false;
          "git.confirmSync" = false;

          # https://github.com/nix-community/vscode-nix-ide
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nixd";
          "nix.serverSettings.nixd.formatting.command" = ["alejandra" "-" "--quiet"];
          "nix.serverSettings.nixd.options.nixos.expr" = "(builtins.getFlake \"${osConfig.programs.nh.flake}\").nixosConfigurations.<name>.options";
        };
      };
    };

    home.packages = with pkgs; [
      alejandra # formatter
      nixd # nix language server
    ];

    xdg.mimeApps.defaultApplications = {
      "text/plain" = "codium.desktop";
      "application/json" = "codium.desktop";
      "text/markdown" = "codium.desktop";
    };

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
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

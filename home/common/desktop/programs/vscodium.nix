{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    
    extensions = with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      jnoortheen.nix-ide
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      editorconfig.editorconfig
    ];

    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
      "editor.tabSize" = 2;
      "files.enableTrash" = false;
      "workbench.startupEditor" = "none";
      "window.titleBarStyle" = "custom";
      "git.detectSubmodules" = false;

      # https://github.com/nix-community/vscode-nix-ide
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil"; # pkgs.nil
    };
  };

  # nix language server
  home.packages = [pkgs.nil];

  home.persistence."/persist${config.home.homeDirectory}".directories = [
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
}

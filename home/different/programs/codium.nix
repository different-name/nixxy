{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
      "files.enableTrash" = false;
      "workbench.startupEditor" = "none";
      "window.titleBarStyle" = "custom";
    };
  };

  home.persistence."/persist/home/different".directories = [
    ".config/VSCodium/CachedDate"
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

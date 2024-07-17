{
  pkgs,
  osConfig,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      editorconfig.editorconfig
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.fontFamily" = "'JetBrains Mono', 'monospace', monospace";
      "files.enableTrash" = false;
      "workbench.startupEditor" = "none";
      "window.titleBarStyle" = "custom";
    };
  };

  home.persistence."/persist/home/${osConfig.nix-files.user}".directories = [
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

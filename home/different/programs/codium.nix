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
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
      "files.enableTrash" = false;
      "workbench.startupEditor" = "none";
      "window.titleBarStyle" = "custom";
    };
  };
}

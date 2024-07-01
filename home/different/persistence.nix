{...}: {
  home.persistence."/persist/home/different" = {
    directories = [
      "dotfiles"
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".cache"
      ".config/vesktop"
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
      ".config/BraveSoftware/Brave-Browser"
      ".config/Slack"
      ".local/share/PrismLauncher"
      # {
      #   directory = ".local/share/Steam";
      #   method = "symlink";
      # }
    ];
    files = [
      # ".screenrc"
    ];
    allowOther = true;
  };
}

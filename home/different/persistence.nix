{...}: {
  home.persistence."/persist/home/different" = {
    directories = [
      "nixos-config"
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".cache"
      ".librewolf/xg1lny11.default/storage"
      ".config/vesktop"
      ".config/VSCodium/CachedDate"
      ".config/VSCodium/Cache"
      ".config/VSCodium/Backups"
      ".config/VSCodium/Code Cache"
      ".config/VSCodium/DawnCache"
      ".config/VSCodium/GPUCache"
      ".config/VSCodium/User/History"
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

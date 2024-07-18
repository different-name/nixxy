{osConfig, ...}: {
  home = {
    persistence."/persist/home/${osConfig.nix-files.user}" = {
      directories = [
        "nix-files"
        "Downloads"
        "Pictures"
        "Documents"
        "Videos"
        ".ssh"
        ".local/share/keyrings"
        ".local/share/direnv"
        ".cache"
        ".config/vesktop"
        ".config/BraveSoftware/Brave-Browser"
        ".config/Slack"
        ".local/share/PrismLauncher"
        ".config/alvr"
        ".config/openvr"
        ".config/goxlr-utility"
        ".local/share/goxlr-utility"
        ".local/state/wireplumber"
        ".local/share/Trash"
        ".config/unityhub"
        ".config/unity3d"
        ".config/libreoffice"
        ".config/GIMP"
        ".local/share/vulkan/" # steam shader cache files?
        ".nv" # OpenGL cache
      ];
      files = [
        ".bash_history"
        ".local/share/fish/fish_history"
      ];
      allowOther = true;
    };

    file.".local/share/fish/fish_history".force = true;
  };
}

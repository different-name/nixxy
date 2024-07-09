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
      ".config/BraveSoftware/Brave-Browser"
      ".config/Slack"
      ".local/share/PrismLauncher"
      ".config/alvr"
      ".confg/openvr"
      ".local/share/goxlr-utility"
    ];
    files = [];
    allowOther = true;
  };
}

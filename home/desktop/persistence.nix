{config, ...}: {
  home.persistence."/persist${config.home.homeDirectory}" = {
    directories = [
      "Downloads"
      "Pictures"
      "Documents"
      "Videos"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".config/vesktop"
      ".config/BraveSoftware/Brave-Browser"
      ".config/Slack"
      ".local/share/PrismLauncher"
      ".local/state/wireplumber"
      ".config/unityhub"
      ".config/unity3d"
      ".config/Unity"
      ".config/blender"
      ".local/share/unity3d"
      ".local/share/VRChatCreatorCompanion"
      ".config/libreoffice"
      ".config/GIMP"
      ".local/share/vulkan/" # steam shader cache files?
      ".nv" # OpenGL cache
      ".config/ente"
      ".local/share/lutris"
      ".android"
    ];
    files = [];
  };
}

{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/persist${config.home.homeDirectory}" = {
    directories = [
      "nix-files"
      ".ssh"
      ".cache"
      ".local/share/Trash"
      ".local/share/fish"
      ".config/qalculate"
      ".local/share/qalculate"
      ".terminfo"

      "code"
      "documents"
      "downloads"
      "pictures"
      "videos"

      ".config/vesktop"
      ".config/BraveSoftware/Brave-Browser"
      ".local/share/PrismLauncher"
      ".local/state/wireplumber" # audio settings
      ".config/blender"
      ".config/libreoffice"
      ".config/GIMP"
      ".local/share/vulkan/" # shader cache files?
      ".nv" # OpenGL cache
      ".local/share/lutris"
      ".local/share/umu" # lutris proton steam runtime
      ".android"
      ".config/Thunar"
      ".config/xfce4/xfconf/xfce-perchannel-xml" # thunar related
      ".config/qBittorrent"
      ".local/share/qBittorrent"
      ".config/heroic"
      ".local/share/osu"
    ];

    files = [
      ".local/share/nix/repl-history"
    ];

    allowOther = true;
  };
}

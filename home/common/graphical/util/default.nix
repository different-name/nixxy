{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./kitty.nix
    ./unity.nix
    ./vscodium.nix
  ];

  options.nix-files.graphical.util.enable = lib.mkEnableOption "Util packages";

  config = lib.mkIf config.nix-files.graphical.util.enable {
    home.packages = with pkgs; [
      android-tools
      bambu-studio
      blender
      gimp-with-plugins
      qalculate-gtk
      qbittorrent
      scrcpy
      inputs.zen-browser.packages."${system}".specific
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # android-tools
        ".android"

        # bambu-studio
        ".config/BambuStudio"
        ".local/share/bambu-studio"
        ".cache/bambu-studio"

        # blender
        ".config/blender"
        ".cache/blender"

        # gimp
        ".config/GIMP"
        ".cache/gimp"

        # qbittorrent
        ".config/qBittorrent"
        ".local/share/qBittorrent"
        ".cache/qBittorrent"

        # zen-browser
        ".zen"
        ".cache/zen"

        ### system level

        # thunar
        ".config/Thunar"
        ".config/xfce4/xfconf/xfce-perchannel-xml"
        ".local/share/gvfs-metadata" # gnome virtual file system data / cache
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
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
      blender
      brave
      gimp-with-plugins
      qalculate-gtk
      qbittorrent-qt5
      scrcpy
      prusa-slicer
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # android-tools
        ".android"

        # blender
        ".config/blender"

        # brave
        ".config/BraveSoftware/Brave-Browser"

        # gimp
        ".config/GIMP"

        # qbittorrent
        ".config/qBittorrent"
        ".local/share/qBittorrent"

        # prusa-slicer
        ".config/PrusaSlicer"

        ### system level

        # thunar
        ".config/Thunar"
        ".config/xfce4/xfconf/xfce-perchannel-xml"
        ".local/share/gvfs-metadata" # gnome virtual file system data / cache
      ];
    };
  };
}

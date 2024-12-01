{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./firefox.nix
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
    ];

    # https://github.com/bambulab/BambuStudio/issues/4669#issuecomment-2334688981
    xdg.desktopEntries.BambuStudio = {
      name = "BambuStudio";
      genericName = "3D Printing Software";
      icon = "BambuStudio";
      exec = "env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json ${pkgs.bambu-studio}/bin/bambu-studio";
      terminal = false;
      type = "Application";
      mimeType = ["model/stl" "model/3mf" "application/vnd.ms-3mfdocument" "application/prs.wavefront-obj" "application/x-amf" "x-scheme-handler/bambustudio"];
      categories = ["Graphics" "3DGraphics" "Engineering"];
      startupNotify = false;
    };

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

        ### system level

        # thunar
        ".config/Thunar"
        ".config/xfce4/xfconf/xfce-perchannel-xml"
        ".local/share/gvfs-metadata" # gnome virtual file system data / cache
      ];
    };
  };
}

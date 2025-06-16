{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./blender.nix
    ./firefox.nix
    ./kitty.nix
    ./unity.nix
    ./vscodium.nix
  ];

  options.nix-files.graphical.util.enable = lib.mkEnableOption "Util packages";

  config = lib.mkIf config.nix-files.graphical.util.enable {
    home.packages = with pkgs; [
      android-tools
      # bambu-studio
      gimp-with-plugins
      protonvpn-gui
      qalculate-gtk
      qbittorrent
      scrcpy
      qpwgraph
    ];

    # https://github.com/bambulab/BambuStudio/issues/4669#issuecomment-2334688981
    # xdg.desktopEntries.BambuStudio = {
    #   name = "BambuStudio";
    #   genericName = "3D Printing Software";
    #   icon = "BambuStudio";
    #   exec = "env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json ${lib.getExe pkgs.bambu-studio}";
    #   terminal = false;
    #   type = "Application";
    #   mimeType = ["model/stl" "model/3mf" "application/vnd.ms-3mfdocument" "application/prs.wavefront-obj" "application/x-amf" "x-scheme-handler/bambustudio"];
    #   categories = ["Graphics" "3DGraphics" "Engineering"];
    #   startupNotify = false;
    # };

    home.persistence."/persist" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        # android-tools
        ".android"

        # bambu-studio
        ".config/BambuStudio"
        ".local/share/bambu-studio"
        ".cache/bambu-studio"

        # gimp
        ".config/GIMP"
        ".cache/gimp"

        # qbittorrent
        ".config/qBittorrent"
        ".local/share/qBittorrent"
        ".cache/qBittorrent"

        # protonvpn-gui
        ".config/Proton"
        ".cache/Proton"

        ### system level

        # thunar
        ".config/Thunar"
        ".local/share/gvfs-metadata" # gnome virtual file system data / cache
      ];

      files = [
        # thunar
        ".config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml"
      ];
    };
  };
}

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
    ];

    home.persistence = lib.mkIf config.nix-files.persistence.enable {
      "/persist${config.home.homeDirectory}" = {
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

          ### system level

          # thunar
          ".config/Thunar"
          ".config/xfce4/xfconf/xfce-perchannel-xml"
          ".local/share/gvfs-metadata" # gnome virtual file system data / cache
        ];
      };

      "/persist${config.home.homeDirectory}-cache" = {
        directories = [
          # brave
          ".config/BraveSoftware/Brave-Browser/Default/Service Worker/CacheStorage"
          ".config/BraveSoftware/Brave-Browser/Default/Service Worker/ScriptCache"
          ".config/BraveSoftware/Brave-Browser/ShaderCache"
          ".config/BraveSoftware/Brave-Browser/GrShaderCache"
          ".config/BraveSoftware/Brave-Browser/Default/GPUCache"
          ".config/BraveSoftware/Brave-Browser/Default/DawnWebGPUCache"
          ".config/BraveSoftware/Brave-Browser/Default/Shared Dictionary/cache"
          ".config/BraveSoftware/Brave-Browser/Default/DawnGraphiteCache"
          ".config/BraveSoftware/Brave-Browser/GraphiteDawnCache"
          ".config/BraveSoftware/Brave-Browser/component_crx_cache"
          ".config/BraveSoftware/Brave-Browser/extensions_crx_cache"
          ".config/BraveSoftware/Brave-Browser/Greaselion/Temp" # greasemonkey / tampermonkey temp files
        ];
      };
    };
  };
}

{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    wayland.windowManager.hyprland.settings.windowrule =
      {
        global = {
          "match:class" = ".*";
          suppress_event = "maximize";
        };

        float-by-class = {
          "match:class" = lib.concatStringsSep "|" [
            "file-roller"
            "org.gnome.FileRoller"
            "xdg-desktop-portal-gtk"
          ];
          float = true;
        };

        float-by-title = {
          "match:title" = lib.concatStringsSep "|" [
            "File Operation Progress"
            "Open Folder"
            "Select what to share"
            "Protontricks"
            "Winetricks.*"
          ];
          float = true;
        };

        tile-by-class = {
          "match:class" = lib.concatStringsSep "|" [
            "battle.net.exe"
          ];
          float = true;
        };

        # keep-sorted start block=yes newline_separated=yes
        games-by-class = {
          "match:class" = lib.concatStringsSep "|" [
            "steam_app_[0-9]+"
            "Paradox Launcher"
            "hl2_linux"
            "osu!"
            "steam_app_default"
            "AcrossTheObelisk.x86_64"
            "TerraTechLinux64.x86_64"
            "diablo iv.exe"
            ''Minecraft(\*)? [0-9\.]+''
            "looking-glass-client"
            "Vintage Story"
          ];
          suppress_event = "fullscreen";
          fullscreen = true;
          workspace = 2;
        };

        librewolf-pip = {
          "match:class" = "librewolf";
          "match:title" = "Picture-in-Picture";
          pin = true;
          size = "480 270";
          keep_aspect_ratio = true;
        };

        pavucontrol = {
          "match:class" = "org.pulseaudio.pavucontrol";
          float = true;
          size = "1000 750";
        };

        qalculate = {
          "match:class" = "qalculate-gtk";
          float = true;
          size = "850 575";
        };

        steam-friends = {
          "match:class" = "steam";
          "match:title" = "Friends List";
          float = true;
          size = "452 800";
        };

        steam-settings = {
          "match:class" = "steam";
          "match:title" = "Steam Settings";
          float = true;
          size = "1275 1083";
        };

        wine-system-tray = {
          "match:title" = "Wine System Tray";
          workspace = "hidden silent";
          no_initial_focus = true;
        };
        # keep-sorted end
      }
      |> lib.mapAttrsToList (name: value: { inherit name; } // value);
  };
}
